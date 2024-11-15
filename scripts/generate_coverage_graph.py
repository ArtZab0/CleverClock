import pandas as pd
import matplotlib.pyplot as plt
import os

# Ensure the coverage directory exists
coverage_dir = 'coverage'
csv_file = os.path.join(coverage_dir, 'test_cov_console_report.csv')
output_image = os.path.join(coverage_dir, 'coverage_graph.png')

# Read the CSV file
df = pd.read_csv(csv_file)

# Calculate total coverage per file
df['Line Coverage'] = df['Covered Lines'] / df['Total Lines'] * 100

# Sort by coverage
df.sort_values('Line Coverage', inplace=True)

# Plot the coverage
plt.figure(figsize=(10, 6))
plt.barh(df['File'], df['Line Coverage'], color='skyblue')
plt.xlabel('Line Coverage (%)')
plt.ylabel('File')
plt.title('Code Coverage per File')

# Add coverage percentages next to the bars
for index, value in enumerate(df['Line Coverage']):
    plt.text(value + 1, index, f"{value:.2f}%", va='center')

plt.tight_layout()
plt.savefig(output_image)
