import pandas as pd
import matplotlib.pyplot as plt

def load_mutation_data(input_file):
      data = pd.read_csv(input_file)
  return data


def count_mutations_by_gene(data):
  gene_counts = data["gene"].value_counts()
      return gene_counts


def plot_mutations_by_gene(gene_counts, output_file):
    plt.figure(figsize=(10, 6))

    gene_counts.head(10).plot(kind="bar")

    plt.title("Top 10 Mutated Genes")
    plt.xlabel("Gene")
    plt.ylabel("Number of Mutations")

    plt.tight_layout()
    plt.savefig(output_file, dpi=300)
    plt.close()
