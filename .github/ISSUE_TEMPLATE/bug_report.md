---
name: Bug Report
about: Report a bug, computational error, biological anomaly, or pipeline failure in Scurator
title: '[BUG] <Short descriptive summary of the bug>'
labels: 'bug, triage'
assignees: ''
---

### Open-Ended Questions (Detailed Error Context)

#### Question 1: Detailed Bug Description and Expected vs. Actual Behavior
Describe the bug, computational error, or biological anomaly in detail. What was expected to happen versus what actually occurred?

*Your answer here:*

#### Question 2: Step-by-Step Reproduction Instructions
Provide exact steps, CLI commands, Python code snippets, or Snakemake execution parameters to reproduce the bug reliably on another system.

*Your answer here:*

#### Question 3: Error Traceback, Logs, and System Messages
Paste the complete stack traceback, console output logs, or terminal error messages encountered during execution.

*Your answer here:*

#### Question 4: Sample Data Record or VCF Snippet
Provide a minimal reproducible snippet of the input data record (e.g., VCF line, MAF row, or configuration file section) that triggers the failure. Ensure no private data is included.

*Your answer here:*

---

### Structured Technical Specifications (Multiple Choice Options)

#### Question 5: Bug Category and Failure Type
Select all categories that best describe the failure:
- [ ] VCF Parsing / Syntax Exception (PySAM or CyVCF2)
- [ ] GPU Out of Memory / CUDA Execution Fault
- [ ] Annotation Mismatch (ClinVar / COSMIC mapping error)
- [ ] Filtering Logic Failure (Incorrect Missense/Frameshift classification)
- [ ] Plot Rendering Failure (Matplotlib / Seaborn 300 DPI export)
- [ ] Installation / Conda Environment Dependency Conflict
- [ ] Command Line Interface (CLI) Argument Parsing Error
- [ ] Snakemake Workflow Rule Failure

#### Question 6: Affected Scurator Module
Which specific source module is failing or producing incorrect output?
- [ ] `src/scurator/data/fetcher.py` (Data Acquisition)
- [ ] `src/scurator/data/qc.py` (Quality Control Engine)
- [ ] `src/scurator/pipeline/filter.py` (Variant Filtering)
- [ ] `src/scurator/pipeline/annotator.py` (Annotation Engine)
- [ ] `src/scurator/pipeline/driver_finder.py` (Driver Gene Profiling)
- [ ] `src/scurator/pipeline/impact_scorer.py` (Functional Scoring)
- [ ] `src/scurator/visualization/oncoplot.py` (Oncoplot Rendering)
- [ ] `src/scurator/visualization/plots.py` (Spectrum Graphics)
- [ ] `src/scurator/utils/gpu_accelerator.py` (GPU Acceleration)
- [ ] `src/scurator/cli.py` (Command Line Interface)
- [ ] `workflow/Snakefile` (Snakemake Rules)

#### Question 7: Execution Context and Environment
Where was Scurator running when the bug occurred?
- [ ] Local Workstation / Laptop
- [ ] High-Performance Computing (HPC) Cluster Node
- [ ] Docker Container Context
- [ ] Isolated Conda / Mamba Environment
- [ ] Cloud Virtual Machine Instance

#### Question 8: Hardware Architecture in Use
What hardware architecture is hosting the execution?
- [ ] x86_64 Intel / AMD CPU Architecture
- [ ] ARM64 Apple Silicon / ARM Server Architecture
- [ ] NVIDIA CUDA GPU Accelerated Environment
- [ ] Multi-Node Distributed Compute Cluster

#### Question 9: Python Runtime Version
Which Python version was active during execution?
- [ ] Python 3.10 (Standard Supported)
- [ ] Python 3.11
- [ ] Python 3.12
- [ ] Other (Please specify in logs)

#### Question 10: Input File Format Triggering the Issue
What input format was being processed when the failure occurred?
- [ ] Somatic VCF v4.2 / v4.3 File
- [ ] Block-Compressed VCF (`.vcf.gz` with Tabix `.tbi`)
- [ ] Mutation Annotation Format (MAF v2.4)
- [ ] Alignment File (BAM / CRAM)
- [ ] NCBI ClinVar Reference File
- [ ] Custom Tabular Dataset (TSV / CSV / Excel)

#### Question 11: Biological and Genomic Context
What biological processing step triggered the issue?
- [ ] Missense Variant Filtering Logic
- [ ] Frameshift and Indel Impact Classification
- [ ] ClinVar Pathogenicity Scoring Alignment
- [ ] COSMIC Driver Gene Census Cross-Referencing
- [ ] Read Depth (DP) or Variant Allele Frequency (VAF) Quality Control

#### Question 12: Operating System Platform
What operating system environment was used?
- [ ] Ubuntu Linux 22.04 / 24.04 LTS
- [ ] RedHat / CentOS / AlmaLinux
- [ ] Debian Linux
- [ ] macOS Sonoma / Sequoia
- [ ] Windows Subsystem for Linux (WSL2)

#### Question 13: Bug Severity and Pipeline Impact
How severely does this bug affect your research workflow?
- [ ] Critical (Complete pipeline crash, no workaround available)
- [ ] High (Pipeline completes but produces incorrect biological results)
- [ ] Medium (Intermittent failure or inconvenient workaround required)
- [ ] Low (Minor cosmetic issue, log typo, or documentation error)

#### Question 14: Occurrence Frequency
How consistently can this bug be reproduced?
- [ ] Consistently Every Time (100% reproducible)
- [ ] Intermittent / Random Execution Failure
- [ ] Specific to Certain Input VCF Files Only
- [ ] Triggered Only Under High Memory or Large Cohort Load

#### Question 15: Installation Method
How was Scurator installed in your environment?
- [ ] Editable Development Mode (`pip install -e .`)
- [ ] Conda / Mamba Environment Import (`mamba env create -f environment.yml`)
- [ ] Pre-Built Docker Container Execution
- [ ] Manual Source Code Run without Package Installation

#### Question 16: Third-Party Dependency Impact
Does the traceback point to a specific underlying third-party library?
- [ ] PySAM or CyVCF2 Low-Level C-Extension Error
- [ ] Pandas or RAPIDS cuDF DataFrame Processing Error
- [ ] Matplotlib or Seaborn Graphics Rendering Exception
- [ ] PyYAML or Configuration Parsing Error

#### Question 17: Security and Anonymization Verification
Confirm data privacy and compliance status:
- [ ] Confirmed NO Protected Health Information (PHI) is included in this report.
- [ ] Confirmed all VCF lines, headers, and code snippets are fully anonymized.
- [ ] The input data comes from a publicly available dataset (e.g., TCGA, ClinVar).

#### Question 18: Troubleshooting Attempts and Workarounds
What troubleshooting steps have you already attempted?
- [ ] Tried clearing intermediate pipeline caches (`.snakemake/` or temp files)
- [ ] Tried falling back from GPU acceleration to CPU multi-threading
- [ ] Tried updating dependencies to match `environment.yml`
- [ ] I have identified the bug source and have a fix or Pull Request ready
