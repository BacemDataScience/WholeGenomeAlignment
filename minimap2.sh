#!/bin/sh

# Initialize Conda for Bash
eval "$(conda shell.bash hook)"

# Define the output directory for Minimap2
output_dir="/home/saadab/wga/minimap2/outputc"

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

# Create a log file to store execution times and statistics
log_file="$output_dir/execution_times.log"
stats_file="$output_dir/alignment_stats.txt"

# Start measuring the total execution time
total_start_time=$(date +%s.%N)

# Activate the Conda environment for Minimap2
echo "Step: Activate Conda Environment for Minimap2 - Started at $(date)" >> "$log_file"
conda activate minimap2  # Replace 'minimap2_env' with your Minimap2 environment name
echo "Step: Activate Conda Environment for Minimap2 - Completed at $(date)" >> "$log_file"

# Define paths to the input genome FASTA files
genome1="/home/saadab/wga/genomes/celegans.fna"
genome2="/home/saadab/wga/genomes/yeast.fna"

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

# Run Minimap2
echo "Step: Run Minimap2 - Started at $(date)" >> "$log_file"
minimap2 -ax asm5 "$genome1" "$genome2" > "$output_dir/alignment.sam"
echo "Step: Run Minimap2 - Completed at $(date)" >> "$log_file"

# Convert SAM to BAM (for processing with Samtools and Qualimap)
samtools view -bS "$output_dir/alignment.sam" > "$output_dir/alignment.bam"

# Sort BAM file
samtools sort "$output_dir/alignment.bam" -o "$output_dir/alignment_sorted.bam"

# Index the sorted BAM file
samtools index "$output_dir/alignment_sorted.bam"

# Generate Alignment Statistics with Samtools
echo "Generating Alignment Statistics with Samtools" >> "$log_file"
samtools flagstat "$output_dir/alignment_sorted.bam" > "$stats_file"

# Generate Alignment Quality Statistics with Qualimap
echo "Generating Alignment Quality Statistics with Qualimap" >> "$log_file"
qualimap bamqc -bam "$output_dir/alignment_sorted.bam" -outfile "$output_dir/qualimap_report.pdf" -outdir "$output_dir/qualimap_output"

# Deactivate the Conda environment
echo "Step: Deactivate Conda Environment - Started at $(date)" >> "$log_file"
conda deactivate
echo "Step: Deactivate Conda Environment - Completed at $(date)" >> "$log_file"

# Stop measuring the total execution time
total_end_time=$(date +%s.%N)

# Calculate and print the total execution time
total_execution_time=$(echo "$total_end_time - $total_start_time" | bc)
echo "Total Execution Time: $total_execution_time seconds" >> "$log_file"

