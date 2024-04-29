#!/bin/bash

# Paths to the input genomes
human_genome1="/home/saadab/wga/genomes/human_genome1.fasta"
human_genome2="/home/saadab/wga/genomes/human_genome2.fasta"

# Output directory
output_dir="/home/saadab/wga/graph/humanVShuman"
mkdir -p "${output_dir}"

# Log file for execution times and script output
log_file="${output_dir}/execution_times.log"
script_output_log="${output_dir}/script_output.log"

# Record the start time
echo "Script started." > "${log_file}"
start_time=$(date +%s)

# Step 1: Construct the Human Genome 1 Graph
echo "Constructing the Human Genome 1 Graph..." >> "${log_file}"
vg construct -r "${human_genome1}" > "${output_dir}/human_genome1_graph.vg"

# Step 2: Indexing the Graph
echo "Indexing the Graph..." >> "${log_file}"
vg index -x "${output_dir}/human_genome1_graph.xg" "${output_dir}/human_genome1_graph.vg"

# Step 3: Aligning the Second Human Genome to the Human Genome 1 Graph
echo "Aligning the Second Human Genome..." >> "${log_file}"
vg giraffe -x "${output_dir}/human_genome1_graph.xg" -f "${human_genome2}" > "${output_dir}/human_genome2_aligned.gam"

# Record the end time and calculate the duration
end_time=$(date +%s)
duration=$((end_time - start_time))
echo "Total Execution Time: ${duration} seconds" >> "${log_file}"

# Optional: Convert the alignment to SAM format for analysis
vg view -a "${output_dir}/human_genome2_aligned.gam" | vg view -JGa - > "${output_dir}/human_genome2_aligned.sam"

echo "Alignment process completed. Check ${output_dir} for output files and ${log_file} for execution logs." >> "${script_output_log}"

