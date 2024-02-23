// git clone https://github.com/rust-lang/rust/blob/0ea7ddcc35a2fcaa5da8a7dcfc118c9fb4a63b95/src/tools/x/src/main.rs
// patched to stop doing python probing, stop the probe, please dont, i have a python
//! Run bootstrap from any subdirectory of a rust compiler checkout.
//!
//! We prefer `exec`, to avoid adding an extra process in the process tree.
//! However, since `exec` isn't available on Windows, we indirect through
//! `exec_or_status`, which will call `exec` on unix and `status` on Windows.
//!
//! We use `powershell.exe x.ps1` on Windows, and `sh -c x` on Unix, those are
//! the ones that call `x.py`. We use `sh -c` on Unix, because it is a standard.
//! We also don't use `pwsh` on Windows, because it is not installed by default;

use std::{
    env, io,
    path::Path,
    process::{self, Command, ExitStatus},
    os::unix::process::CommandExt,
};

fn main() {
    match env::args().skip(1).next().as_deref() {
        Some("--wrapper-version") => {
            println!("0.1.0");
            return;
        }
        _ => {}
    }
    let current = match env::current_dir() {
        Ok(dir) => dir,
        Err(err) => {
            eprintln!("Failed to get current directory: {err}");
            process::exit(1);
        }
    };

    for dir in current.ancestors() {
        let candidate = dir.join("x.py");
        if candidate.exists() {
            let shell_script_candidate = dir.join("x");
            let mut cmd: Command;
            if shell_script_candidate.exists() {
                cmd = Command::new(dir.join("x"));
                cmd.args(env::args().skip(1)).current_dir(dir);
            } else {
                panic!("error: cry about it");
            }
            let error = cmd.exec();
            eprintln!("Failed to invoke `{:?}`: {}", cmd, error);
        }
    }

    eprintln!(
        "x.py not found. Please run inside of a checkout of `https://github.com/rust-lang/rust`."
    );

    process::exit(1);
}
