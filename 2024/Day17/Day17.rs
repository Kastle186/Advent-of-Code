// Day17.rs

use std::env;
use std::fs::read_to_string;

fn main() {
    let args: Vec<String> = env::args().collect(); // Arg[0] is the program's name.

    let input: Vec<String> =
        read_to_string(args[1].clone())
        .unwrap()
        .lines()
        .map(String::from)
        .collect();

    println!("{:#?}", input)
}
