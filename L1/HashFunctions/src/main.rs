use base64::{Engine as _, engine::general_purpose};
use std::{
    fs::File,
    io::{self, Read, Write},
};

use sha3::{Digest, Sha3_256};

fn main() -> io::Result<()> {
    println!("Type a filename to hash");

    loop {
        print!("> ");

        io::stdout().flush()?;

        let mut input = String::new();
        match io::stdin().read_line(&mut input) {
            Ok(0) => break Ok(()),
            Ok(_) => {}
            Err(error) => return Err(error),
        }

        let filename = input.trim();

        match File::open(filename) {
            Ok(mut file) => {
                let mut buffer = Vec::new();
                if let Err(e) = file.read_to_end(&mut buffer) {
                    eprintln!("Failed to read '{}': {}", filename, e);
                    continue;
                }
                let mut hasher = Sha3_256::new();
                hasher.update(&buffer);
                let hash = hasher.finalize();

                match std::str::from_utf8(&buffer) {
                    Ok(text) => println!("Content of file '{}'", text),
                    Err(e) => {
                        eprintln!("'{}' is not valid UTF-8: {}", filename, e);
                        continue;
                    }
                }

                println!("Hex: {:?}", general_purpose::STANDARD.encode(hash));
                println!("Hashed text: {:?}", hash);
                println!("({}): {:?}", filename, hash);
            }
            Err(e) => {
                eprintln!("Cannot open '{}': {}", filename, e)
            }
        }
    }
}
