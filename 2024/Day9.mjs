#!/usr/bin/env node

import fs from 'node:fs';

function main() {
    const inputDisk = fs.readFileSync(process.argv[2], 'utf8').trim();
    console.log("INPUT: %s", inputDisk);
    const diskLayout = diskMapToLayout(inputDisk);
    console.log("LAYOUT: %s", diskLayout.join(''));
}

/* HELPER FUNCTIONS! */

// NOTE: We will have to get more creative with data structures for the real input,
//       as processing digits alone will only lead us so far as to id=9 (i.e. 10 files).
//       And the puzzle input is much, much larger than that.

function diskMapToLayout(diskMap) {
    let isFile = true;
    let fileId = 0;
    const layout = []

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
