---
name: Feature Request
about: Propose a new feature, biological annotation pipeline, GPU optimization, or scientific module for Scurator
title: '[FEATURE] <Short descriptive title of the proposed feature>'
labels: 'enhancement, triage'
assignees: ''
---

### Open-Ended Questions (Detailed Scientific Context)

#### Question 1: Problem Statement and Biological Motivation
Describe the specific scientific bottleneck, biological gap, or computational limitation you are currently facing. What exact problem does this feature solve?

*Your answer here:*

#### Question 2: Proposed Algorithmic Specification and Step-by-Step Logic
Provide a detailed step-by-step description of the proposed logic, mathematical formulations, filtering thresholds, or bioinformatics workflow.

*Your answer here:*

#### Question 3: Input and Output Data Schema Details
Provide concrete examples, sample lines (e.g., VCF header lines, MAF columns, or ClinVar annotations), or schema definitions for both inputs and outputs.

*Your answer here:*

#### Question 4: Expected Scientific Impact and Academic Utility
How will this feature advance cancer driver mutation profiling or Q1 academic research workflows? What value does it add to the Scurator community?

*Your answer here:*

---

### Structured Technical Specifications (Multiple Choice Options)

#### Question 5: Primary Domain Focus
Select all domains that apply to this proposed feature:
- [ ] Somatic Variant Filtering (Missense / Frameshift / Nonsense)
- [ ] Functional Impact Scoring and Pathogenicity Prediction
- [ ] GPU Acceleration and Vectorized Processing
- [ ] Publication Graphics Engine (Oncoplot / Spectrum Plots)
- [ ] Data Acquisition, Quality Control, and VCF Ingestion
- [ ] Workflow Orchestration (Snakemake Rule Integration)
- [ ] Command Line Interface (CLI) and Configuration Management
- [ ] API Development and Python Kütüphane Integration

#### Question 6: Target Genomic Variant Classes
Which variant classes will be processed or impacted by this feature?
- [ ] Single Nucleotide Variants (SNVs)
- [ ] Insertions and Deletions (Indels)
- [ ] Frameshift Mutations
- [ ] Non-synonymous Missense Mutations
- [ ] Copy Number Variants (CNVs)
- [ ] Structural Variants (SVs) and Gene Fusions

#### Question 7: Target Cancer Cohort Scope
What is the intended scope of cancer datasets for this feature?
- [ ] Pan-Cancer Broad Genomics Profiling
- [ ] Solid Tumors (e.g., TCGA-BRCA, TCGA-LUAD, TCGA-COAD)
- [ ] Hematological Malignancies
- [ ] Targeted Gene Panels / Custom Sequencing Cohorts
- [ ] Whole Exome Sequencing (WES)
- [ ] Whole Genome Sequencing (WGS)

#### Question 8: External Annotation Databases
Which annotation sources or databases does this feature interact with?
- [ ] NCBI ClinVar Database
- [ ] COSMIC Cancer Gene Census (CGC)
- [ ] dbNSFP Functional Predictions
- [ ] AlphaMissense Pathogenicity Scores
- [ ] gnomAD Population Frequencies
- [ ] Ensembl Variant Effect Predictor (VEP)
- [ ] Custom User-Defined Reference Files

#### Question 9: Hardware Execution Profile
What execution hardware environment is required for this feature?
- [ ] CPU Multi-Threading (Parallel Multiprocessing)
- [ ] NVIDIA GPU Acceleration (RAPIDS cuDF Engine)
- [ ] High-Performance Computing (HPC) Distributed Nodes
- [ ] Cloud-Native Docker Execution Context

#### Question 10: Estimated Memory Resource Footprint
What is the expected RAM/VRAM consumption during execution?
- [ ] Minimal Footprint (< 4 GB RAM)
- [ ] Moderate Footprint (4 GB to 16 GB RAM)
- [ ] High Footprint (16 GB to 64 GB RAM)
- [ ] Extreme Footprint (> 64 GB RAM / Big Data Cluster)

#### Question 11: Target Architecture Modules
Which specific modules in the Scurator codebase will require modification?
- [ ] `src/scurator/data/fetcher.py` (Data Acquisition)
- [ ] `src/scurator/data/qc.py` (Quality Control Engine)
- [ ] `src/scurator/pipeline/filter.py` (Variant Filtering)
- [ ] `src/scurator/pipeline/annotator.py` (Annotation Engine)
- [ ] `src/scurator/pipeline/driver_finder.py` (Driver Gene Profiling)
- [ ] `src/scurator/pipeline/impact_scorer.py` (Functional Scoring)
- [ ] `src/scurator/visualization/oncoplot.py` (Oncoplot Rendering)
- [ ] `src/scurator/visualization/plots.py` (Spectrum Graphics)
- [ ] `src/scurator/utils/gpu_accelerator.py` (GPU Acceleration)
- [ ] `workflow/Snakefile` (Snakemake Rules)

#### Question 12: Input File Format Requirements
Which input data formats are necessary for this feature?
- [ ] VCF v4.2 / v4.3 (Variant Call Format)
- [ ] Compressed VCF (`.vcf.gz` with Index `.tbi`)
- [ ] MAF v2.4 (Mutation Annotation Format)
- [ ] Alignment Files (BAM / CRAM)
- [ ] Raw Sequence Reads (FASTQ / FQ)
- [ ] Tabular Data (TSV / CSV / Excel)
- [ ] Structured Config (JSON / YAML)

#### Question 13: Output Artifact Expectations
What format should the output results be generated in?
- [ ] High-Resolution Publication PNG (300 DPI)
- [ ] Scalable Vector Graphics (SVG)
- [ ] Annotated Tabular File (CSV / TSV / Excel)
- [ ] Processed VCF / MAF Output
- [ ] Structured JSON Metric Report
- [ ] Interactive Plotly HTML Chart

#### Question 14: Computational Performance Priorities
Which performance metrics are most critical for this feature?
- [ ] Maximizing Processing Speed (Throughput)
- [ ] Minimizing System Memory (RAM / VRAM Usage)
- [ ] Parallelizing Disk File I/O
- [ ] Vectorizing Numerical Calculations
- [ ] Optimizing Pipeline Caching and Intermediate Storage

#### Question 15: Automated Test Requirements
What automated testing assets will be included or required?
- [ ] Synthetic VCF Test Fixture (`data/test_fixtures/`)
- [ ] Pytest Unit Tests (`tests/`)
- [ ] Integration Tests
- [ ] Performance Benchmark Script (`scripts/`)
- [ ] Regression Test Coverage

#### Question 16: Workflow Compatibility
How should this feature interact with pipeline workflow tools?
- [ ] Direct Python API Call
- [ ] Command Line Interface (CLI Subcommand)
- [ ] Snakemake Rule Target
- [ ] Independent Docker Container Run

#### Question 17: Open Science and FAIR Standards Compliance
Confirm the open science status of this feature request:
- [ ] Complies with European Open Science Cloud (EOSC) FAIR principles.
- [ ] Compatible with European Union Public Licence v1.2 (EUPL-1.2).
- [ ] All datasets used are publicly accessible and non-proprietary.
- [ ] Does not contain any Protected Health Information (PHI).

#### Question 18: Contributor Commitment
What is your level of involvement in implementing this feature?
- [ ] I plan to submit a Pull Request with the complete implementation.
- [ ] I can assist with writing code and unit tests.
- [ ] I can provide domain expertise, test data, and review code.
- [ ] I am proposing the idea for the community to implement.
