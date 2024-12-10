#!/usr/bin/env node

import fs from 'node:fs';

function main() {
    /* SETUP! */

    const inputDisk = fs.readFileSync(process.argv[2], 'utf8').trim();

    // We have to know the sizes (number of blocks) of each file, as well as the
    // size of each one of the free space segments between them to later implement
    // the defragmentation/compression algorithm.
    const {fileBlocks, spaceBlocks} = separateDiskMapContents(inputDisk);

    // Next, we build an array of tuples representing how many times each file ID
    // appears in each segment of the compressed disk image.
}

/* HELPER FUNCTIONS! */

function separateDiskMapContents(diskMap) {
    const fileBlocks = [];
    const spaceBlocks = [];

    // We know that the number of blocks of each file and each segment of contiguous
    // space are alternated in the disk map. So, if we're starting with file blocks,
    // and arrays are 0-index-based, then all index pair numbers are file blocks and
    // all odd numbers are space blocks.

    for (let index in diskMap) {
        const numBlocks = diskMap[index];
        index % 2 == 0 ? fileBlocks.push(numBlocks) : spaceBlocks.push(numBlocks);
    }

    return {
        fileBlocks: fileBlocks,
        spaceBlocks: spaceBlocks,
    }
}

/* DRAFT FUNCTIONS! */

function diskMapToLayout(diskMap) {
    let isFile = true;
    let fileId = 0;
    const layout = [];

    // Each digit of the map indicates how many blocks of memory the item takes.
    // 0 and even numbers refer to files, and uneven numbers refer to free space.
    // So, we read through the map, and generate the layout following these rules.

    for (let digit of diskMap) {
        // File: Write the ID
        // Free Space: Write a dot '.'
        let layoutChar = isFile ? fileId.toString() : '.';
        layout.push(layoutChar.repeat(parseInt(digit)));

        // Alternate between file and free space as per the rules. Only increase
        // the id value for files though, as empty space is unmarked.

        if (!isFile) {
            isFile = true;
            continue;
        }

        isFile = false;
        fileId++;
    }

    return layout;
}

main()
