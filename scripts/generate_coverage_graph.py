# scripts/generate_coverage_graph.py

import sys
import pandas as pd
import matplotlib.pyplot as plt

def main(csv_path, output_image):
    # Read the CSV coverage data
    df = pd.read_csv(csv_path)

    # Example: Summarize coverage per file
    summary = df.groupby('file')['coverage'].mean().reset_index()

    # Sort the summary for better visualization
    summary = summary.sort_values(by='coverage', ascending=False)

    # Plot the coverage
    plt.figure(figsize=(10, 8))
    plt.barh(summary['file'], summary['coverage'], color='skyblue')
    plt.xlabel('Coverage (%)')
    plt.title('Flutter Test Coverage by File')
    plt.gca().invert_yaxis()  # Highest coverage at the top
    plt.tight_layout()

    # Save the plot
    plt.savefig(output_image)
    print(f"Coverage graph saved to {output_image}")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python generate_coverage_graph.py <input_csv> <output_image>")
        sys.exit(1)
    csv_path = sys.argv[1]
    output_image = sys.argv[2]
    main(csv_path, output_image)
