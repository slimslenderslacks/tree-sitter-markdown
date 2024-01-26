#include <stdio.h>
#include <tree_sitter/api.h>

int main() {
    // Initialize the Tree-sitter library
    TSParser *parser = ts_parser_new();

    // Load the Markdown language
    TSLanguage *markdown_language = ts_language_load_path("path/to/markdown.so");

    if (!markdown_language) {
        fprintf(stderr, "Error loading Markdown language\n");
        return 1;
    }

    // Set the parser's language to Markdown
    ts_parser_set_language(parser, markdown_language);

    // Read the Markdown input from a file (change this path to your Markdown file)
    FILE *input_file = fopen("path/to/your/markdown-file.md", "r");
    if (!input_file) {
        fprintf(stderr, "Error opening input file\n");
        return 1;
    }

    // Get the size of the input file
    fseek(input_file, 0, SEEK_END);
    long file_size = ftell(input_file);
    rewind(input_file);

    // Read the file content into a buffer
    char *input_buffer = (char *)malloc(file_size + 1);
    fread(input_buffer, 1, file_size, input_file);
    input_buffer[file_size] = '\0';

    // Create a Tree-sitter input document
    TSInput input = ts_input_from_string(input_buffer);

    // Parse the input
    TSNode root_node = ts_parser_parse_string(parser, NULL, input);

    // Check if parsing was successful
    if (ts_node_is_null(root_node)) {
        fprintf(stderr, "Parsing failed\n");
        return 1;
    }

    // Perform your desired operations with the parsed tree here
    // For example, you can traverse the tree and analyze the Markdown document's structure.

    // Clean up resources
    ts_parser_delete(parser);
    ts_language_delete(markdown_language);
    fclose(input_file);
    free(input_buffer);

    return 0;
}

