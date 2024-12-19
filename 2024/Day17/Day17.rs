// Day17.rs

use std::{
    env,
    collections::HashMap,
    convert::TryFrom,
    convert::TryInto,
    fs::read_to_string,
};

enum ChronoOpcode {
    ADV = 0,
    BXL = 1,
    BST = 2,
    JNZ = 3,
    BXC = 4,
    OUT = 5,
    BDV = 6,
    CDV = 7
}

// In Rust, we need to do some additional processing to be able to use numbers
// and enum values, like we do in C.

impl TryFrom<i8> for ChronoOpcode {
    type Error = ();

    // The try_from() name is actually defined somewhere by TryFrom<>, so we can't
    // name our casting function anything else.

    fn try_from(value: i8) -> Result<ChronoOpcode, ()> {
        match value {
            0 => Ok(ChronoOpcode::ADV),
            1 => Ok(ChronoOpcode::BXL),
            2 => Ok(ChronoOpcode::BST),
            3 => Ok(ChronoOpcode::JNZ),
            4 => Ok(ChronoOpcode::BXC),
            5 => Ok(ChronoOpcode::OUT),
            6 => Ok(ChronoOpcode::BDV),
            7 => Ok(ChronoOpcode::CDV),
            _ => Err(())
        }
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();

    // Read our input into an array of its lines.
    let input: Vec<String> =
        read_to_string(args[1].clone())  // Args[0] is the program's name.
        .unwrap()
        .lines()
        .map(String::from)
        .collect();

    let (mut vm_registers, vm_program): (HashMap<char,i64>, Vec<i8>)
        = setup_chrono_vm(&input);

    // PART ONE! //

    // println!("\nREGISTERS: {:#?}", vm_registers);
    // println!("\nPROGRAM: {:?}", vm_program);

    let chrono_output: String = run_chrono_vm(&mut vm_registers, &vm_program);
    println!("PART ONE: {}", chrono_output);

    // PART TWO! //
}

fn setup_chrono_vm(setup: &Vec<String>) -> (HashMap<char,i64>, Vec<i8>) {
    // The first three lines of our input are the registers in the format:
    // Register <Letter>: <Value>

    let registers = HashMap::<char,i64>::from([
        ('A', unwrap_register(setup[0].clone())),
        ('B', unwrap_register(setup[1].clone())),
        ('C', unwrap_register(setup[2].clone())),
    ]);

    // The fourth line is empty, and the fifth line contains the the program's
    // instructions separated by commas. Same format as the registers:
    // Program: <comma-separated instruction opcodes>

    let program: Vec<i8> = setup[4].split(':')
                                   .collect::<Vec<&str>>()[1]
                                   .trim()
                                   .split(',')
                                   .map(|opcode| opcode.parse::<i8>().unwrap())
                                   .collect();

    (registers, program)
}

fn unwrap_register(reg_raw_str: String) -> i64 {
    reg_raw_str.split(':')
               .collect::<Vec<&str>>()[1]
               .trim()
               .parse::<i64>()
               .unwrap()
}

// Virtual Machine Operand Types:
//
// - Adv: Combo Operand
// - Bxl: Literal Operand
// - Bst: Combo Operand
// - Jnz: Literal Operand
// - Bxc: Ignores Operand
// - Out: Combo Operand
// - Bdv: Combo Operand
// - Cdv: Combo Operand

fn run_chrono_vm(registers: &mut HashMap<char,i64>, program: &Vec<i8>) -> String {
    let mut result: Vec<i64> = Vec::new();

    for i in (0..program.len()).step_by(2) {
        let instr = ChronoOpcode::try_from(program[i]).unwrap();
        let operand = program[i + 1];

        match instr {
            ChronoOpcode::ADV => instr_adv(operand, registers),
            ChronoOpcode::BXL => instr_bxl(operand, registers),
            ChronoOpcode::BST => instr_bst(operand, registers),
            ChronoOpcode::JNZ => println!("Under construction!"),
            ChronoOpcode::BXC => instr_bxc(operand, registers),
            ChronoOpcode::OUT => println!("Under construction!"),
            ChronoOpcode::BDV => instr_bdv(operand, registers),
            ChronoOpcode::CDV => instr_cdv(operand, registers)
        }
    }

    "Under Construction!".to_string()
}

fn instr_adv(op: i8, regs: &mut HashMap<char,i64>) {
    instr_div(get_combo_operand(op, &regs), 'A', regs);
}

fn instr_bxl(op: i8, regs: &mut HashMap<char,i64>) {
    let b_reg_value: i64 = regs[&'B'];
    let bxl_result: i64 = b_reg_value ^ (op as i64);
    regs.insert('B', bxl_result);
}

fn instr_bst(op: i8, regs: &mut HashMap<char,i64>) {
    let actual_op = get_combo_operand(op, &regs);
    let bst_result: i64 = actual_op % 8;
    regs.insert('B', bst_result);
}

// fn instr_jnz(op: i8, regs: &HashMap<char,i64>, out_vec: &Vec<i64>) {
// }

fn instr_bxc(_op: i8, regs: &mut HashMap<char,i64>) {
    let op1: i64 = regs[&'B'];
    let op2: i64 = regs[&'C'];
    let bxc_result: i64 = op1 ^ op2;
    regs.insert('B', bxc_result);
}

// fn instr_out(op: i8, regs: &HashMap<char,i64>, out_vec: &Vec<i64>) {
// }

fn instr_bdv(op: i8, regs: &mut HashMap<char,i64>) {
    instr_div(get_combo_operand(op, &regs), 'B', regs);
}

fn instr_cdv(op: i8, regs: &mut HashMap<char,i64>) {
    instr_div(get_combo_operand(op, &regs), 'C', regs);
}

fn instr_div(combo_op: i64, reg_name: char, regs: &mut HashMap<char,i64>) {
    let numerator: i64 = regs[&'A'];
    let denominator: i64 = i64::pow(2, combo_op.try_into().unwrap());
    let div_result: i64 = numerator / denominator;
    regs.insert(reg_name, div_result);
}

fn get_combo_operand(operand: i8, registers: &HashMap<char,i64>) -> i64 {
    match operand {
        0 | 1 | 2 | 3 => operand.into(),
        4 => registers[&'A'],
        5 => registers[&'B'],
        6 => registers[&'C'],
        _ => -1
    }
}
