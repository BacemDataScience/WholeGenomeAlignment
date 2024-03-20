#!/bin/sh

# Initialize Conda for Bash
eval "$(conda shell.bash hook)"

# Define the output directory for DIALIGN-WGA
dialign_wga_output_dir="/path/wga/dialign-wga/output"

# Create a log file to store execution times
log_file="$dialign_wga_output_dir/execution_times.log"

# Start measuring the total execution time
total_start_time=$(date +%s.%N)

# Activate the Conda environment for DIALIGN-WGA
#echo "Step: Activate Conda Environment for DIALIGN-WGA - Started at $(date)" >> "$log_file"
#conda activate dialign_wga_env  # Replace 'dialign_wga_env' with your DIALIGN-WGA environment name
#echo "Step: Activate Conda Environment for DIALIGN-WGA - Completed at $(date)" >> "$log_file"

# Define paths to the input genome FASTA files
genome1="/path/wga/genomes/human_genome1.fasta"
genome2="/path/wga/genomes/human_genome2.fasta"

# Combine the genomes into a single file for DIALIGN
#combined_genome="$dialign_wga_output_dir/combined_genomes.fasta"
#cat "$genome1" "$genome2" > "$combined_genome"

# Create the output directory if it doesn't exist
mkdir -p "$dialign_wga_output_dir"

# Run DIALIGN-WGA
echo "Step: Run DIALIGN-WGA - Started at $(date)" >> "$log_file"

#dialign2-2 -n "$combined_genome" > "$dialign_wga_output_dir/dialign_output.txt"
dialign2-2 -n $genome1 $genome2  > "$dialign_wga_output_dir/dialign_output.txt"

echo "Step: Run DIALIGN-WGA - Completed at $(date)" >> "$log_file"

# Deactivate the Conda environment
echo "Step: Deactivate Conda Environment - Started at $(date)" >> "$log_file"
conda deactivate
echo "Step: Deactivate Conda Environment - Completed at $(date)" >> "$log_file"

# Stop measuring the total execution time
total_end_time=$(date +%s.%N)

# Calculate and print the total execution time
total_execution_time=$(echo "$total_end_time - $total_start_time" | bc)
echo "Total Execution Time: $total_execution_time seconds" >> "$log_file"

