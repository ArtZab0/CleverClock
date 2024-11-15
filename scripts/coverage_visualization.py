import pandas as pd
import matplotlib.pyplot as plt
import sys
import os

def main():
    # Check if coverage CSV file path is provided
    if len(sys.argv) < 2:
        print("Usage: python coverage_visualization.py <path_to_coverage_csv>")
        sys.exit(1)

    coverage_csv_path = sys.argv[1]

    # Check if the file exists
    if not os.path.isfile(coverage_csv_path):
        print(f"Coverage CSV file not found at: {coverage_csv_path}")
        sys.exit(1)

    # Read the coverage CSV file
    df = pd.read_csv(coverage_csv_path)

    # Calculate coverage percentage
    df['coverage_percentage'] = (df['line_hit'] / df['line_found']) * 100

    # Sort by coverage percentage
    df = df.sort_values(by='coverage_percentage', ascending=False)

    # Plot the coverage percentage for each file
    plt.figure(figsize=(10, 6))
    bars = plt.barh(df['file'], df['coverage_percentage'], color='skyblue')
    plt.xlabel('Coverage Percentage')
    plt.ylabel('File')
    plt.title('Code Coverage per File')
    plt.gca().invert_yaxis()  # Highest coverage at the top

    # Add coverage percentage labels to each bar
    for bar, percentage in zip(bars, df['coverage_percentage']):
        plt.text(bar.get_width() + 1, bar.get_y() + bar.get_height()/2,
                 f'{percentage:.1f}%', va='center')

    plt.xlim(0, 100)
    plt.tight_layout()
    plt.savefig('coverage_report.png')

if __name__ == '__main__':
    main()
