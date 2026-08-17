#!/usr/bin/env python3
# ==============================================================================
# SCURATOR: Somatic Driver Mutation Profiling Framework
# GDC API Somatic Mutation Data Ingestion Tool (scripts/download_tcga_maf.py)
#
# Standards Compliance:
# * European Open Science Cloud (EOSC) FAIR Principles (Findable, Accessible, Interoperable, Reusable)
# * Google Open Source Software (OSS) Engineering Practice Standards
# * European Union Public Licence v1.2 (EUPL-1.2)
# ==============================================================================

import argparse
import hashlib
import json
import logging
import sys
from pathlib import Path
from typing import Any, Dict, List

import requests
from tqdm import tqdm

# Configure structured logger
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
    handlers=[logging.StreamHandler(sys.stdout)]
)
logger = logging.getLogger("scurator.downloader")

GDC_FILES_ENDPOINT = "https://api.gdc.cancer.gov/files"
GDC_DATA_ENDPOINT = "https://api.gdc.cancer.gov/data"


def parse_arguments() -> argparse.Namespace:
    """Parse command-line arguments for GDC MAF data download."""
    parser = argparse.ArgumentParser(
        description="Automated GDC API Somatic Mutation Downloader for TCGA Datasets"
    )
    parser.add_argument(
        "--project",
        type=str,
        default="TCGA-BRCA",
        help="Target TCGA project identifier (e.g., TCGA-BRCA, TCGA-LUAD, TCGA-COAD)"
    )
    parser.add_argument(
        "--output-dir",
        type=str,
        default="data/raw",
        help="Destination directory for downloaded somatic mutation files"
    )
    parser.add_argument(
        "--file-limit",
        type=int,
        default=5,
        help="Maximum number of files to retrieve (use 0 for all available files)"
    )
    parser.add_argument(
        "--data-type",
        type=str,
        default="Masked Somatic Mutation",
        help="GDC data_type filter (e.g., 'Masked Somatic Mutation')"
    )
    return parser.parse_args()


def construct_gdc_query(project_id: str, data_type: str, limit: int) -> Dict[str, Any]:
    """Construct GDC JSON search query filter payload."""
    filters = {
        "op": "and",
        "content": [
            {
                "op": "in",
                "content": {
                    "field": "cases.project.project_id",
                    "value": [project_id]
                }
            },
            {
                "op": "in",
                "content": {
                    "field": "files.data_type",
                    "value": [data_type]
                }
            },
            {
                "op": "in",
                "content": {
                    "field": "files.access",
                    "value": ["open"]
                }
            }
        ]
    }

    params: Dict[str, Any] = {
        "filters": json.dumps(filters),
        "fields": "file_id,file_name,file_size,md5sum,cases.submitter_id",
        "format": "JSON"
    }

    if limit > 0:
        params["size"] = str(limit)
    else:
        params["size"] = "1000"

    return params


def verify_file_md5(file_path: Path, expected_md5: str) -> bool:
    """Verify downloaded file against official GDC MD5 checksum."""
    hasher = hashlib.md5()
    with open(file_path, "rb") as f:
        for chunk in iter(lambda: f.read(65536), b""):
            hasher.update(chunk)
    return hasher.hexdigest().lower() == expected_md5.lower()


def download_file_stream(file_id: str, file_name: str, file_size: int, output_path: Path, expected_md5: str) -> None:
    """Stream download binary file from GDC Data endpoint with progress tracking."""
    url = f"{GDC_DATA_ENDPOINT}/{file_id}"
    response = requests.get(url, stream=True, timeout=60)
    response.raise_for_status()

    logger.info("Downloading %s (Size: %.2f MB)", file_name, file_size / (1024 * 1024))

    with open(output_path, "wb") as f, tqdm(
        total=file_size,
        unit="B",
        unit_scale=True,
        unit_divisor=1024,
        desc=file_name
    ) as progress_bar:
        for chunk in response.iter_content(chunk_size=32768):
            if chunk:
                f.write(chunk)
                progress_bar.update(len(chunk))

    if verify_file_md5(output_path, expected_md5):
        logger.info("Integrity verified (MD5 matches): %s", file_name)
    else:
        logger.error("MD5 mismatch for file %s. File may be corrupted.", file_name)
        raise IOError(f"MD5 verification failed for {file_name}")


def main() -> None:
    """Main execution flow for TCGA data acquisition."""
    args = parse_arguments()
    output_dir = Path(args.output_dir) / args.project
    output_dir.mkdir(parents=True, exist_ok=True)

    logger.info("Querying GDC API for project: %s (Type: %s)", args.project, args.data_type)
    query_params = construct_gdc_query(args.project, args.data_type, args.file_limit)

    response = requests.get(GDC_FILES_ENDPOINT, params=query_params, timeout=30)
    response.raise_for_status()
    query_data = response.json()

    hits: List[Dict[str, Any]] = query_data.get("data", {}).get("hits", [])
    logger.info("Found %d matching open-access somatic mutation files.", len(hits))

    if not hits:
        logger.warning("No files found matching criteria for project %s.", args.project)
        return

    for hit in hits:
        file_id = hit["file_id"]
        file_name = hit["file_name"]
        file_size = hit["file_size"]
        md5sum = hit["md5sum"]
        dest_file = output_dir / file_name

        if dest_file.exists() and verify_file_md5(dest_file, md5sum):
            logger.info("File %s already exists and is verified. Skipping.", file_name)
            continue

        download_file_stream(file_id, file_name, file_size, dest_file, md5sum)

    logger.info("All downloads completed successfully. Output stored in: %s", output_dir)


if __name__ == "__main__":
    main()
