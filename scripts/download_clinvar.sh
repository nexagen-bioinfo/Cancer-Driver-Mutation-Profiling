#!/usr/bin/env bash
# ==============================================================================
# SCURATOR: Somatic Driver Mutation Profiling Framework
# Automated NCBI ClinVar Database Downloader (scripts/download_clinvar.sh)
#
# Standards Compliance:
# * European Open Science Cloud (EOSC) FAIR Principles (Findable, Accessible, Interoperable, Reusable)
# * Google Open Source Software (OSS) Shell Scripting Practice Guidelines
# * European Union Public Licence v1.2 (EUPL-1.2)
# ==============================================================================

set -euo pipefail

# Output directory definition
TARGET_DIR="data/external"
CLINVAR_BASE_URL="https://ftp.ncbi.nlm.nih.gov/pub/clinvar/vcf_GRCh38"
VCF_FILE="clinvar.vcf.gz"
TBI_FILE="clinvar.vcf.gz.tbi"
MD5_FILE="clinvar.vcf.gz.md5"

echo "[INFO] Starting automated ClinVar reference database download..."
mkdir -p "${TARGET_DIR}"

# Function to check command availability
check_command() {
    if ! command -v "$1" &> /dev/null; then
        echo "[ERROR] Required utility '$1' is not installed in the PATH." >&2
        exit 1
    fi
}

check_command curl
check_command tabix
check_command md5sum

# Step 1: Download VCF and Index files
cd "${TARGET_DIR}"

echo "[INFO] Downloading ${VCF_FILE}..."
curl -fsSL "${CLINVAR_BASE_URL}/${VCF_FILE}" -o "${VCF_FILE}"

echo "[INFO] Downloading ${TBI_FILE}..."
curl -fsSL "${CLINVAR_BASE_URL}/${TBI_FILE}" -o "${TBI_FILE}"

echo "[INFO] Downloading ${MD5_FILE}..."
curl -fsSL "${CLINVAR_BASE_URL}/${MD5_FILE}" -o "${MD5_FILE}"

# Step 2: Verify MD5 Checksum Integrity
echo "[INFO] Verifying MD5 checksum integrity..."
if command -v md5sum &> /dev/null; then
    # Extract expected MD5 string from NCBI md5 file
    EXPECTED_MD5=$(awk '{print $1}' "${MD5_FILE}")
    CALCULATED_MD5=$(md5sum "${VCF_FILE}" | awk '{print $1}')
    
    if [ "${EXPECTED_MD5}" == "${CALCULATED_MD5}" ]; then
        echo "[SUCCESS] MD5 checksum verified successfully: ${CALCULATED_MD5}"
    else
        echo "[ERROR] MD5 checksum mismatch!" >&2
        echo "Expected:   ${EXPECTED_MD5}" >&2
        echo "Calculated: ${CALCULATED_MD5}" >&2
        exit 1
    fi
fi

# Step 3: Validate Tabix Index
if [ ! -f "${TBI_FILE}" ]; then
    echo "[WARNING] Tabix index missing. Generating index with tabix..."
    tabix -p vcf "${VCF_FILE}"
fi

echo "[SUCCESS] ClinVar reference database successfully prepared at ${TARGET_DIR}/${VCF_FILE}"
