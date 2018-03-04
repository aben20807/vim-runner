use std::io;

macro_rules! parse_line {
    ($($t: ty),+) => ({
        let mut a_str = String::new();
        io::stdin().read_line(&mut a_str).expect("read error");
        let mut a_iter = a_str.split_whitespace();
        (
            $(
            a_iter.next().unwrap().parse::<$t>().expect("parse error"),
            )+
        )
    })
}

fn main() {
    println!("Hello rust!");
    let (a0,a1,a2) = parse_line!(i32,i32,i32);
    println!("{}", a0 + a1 + a2);
}
