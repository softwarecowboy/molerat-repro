use molerat::Molerat;
use std::{thread, time::Duration};

#[derive(Clone, Debug)]
enum Message {
    Ping,
}

fn main() -> std::io::Result<()> {
    let mut molerat = Molerat::<Message>::new_mcp("molerat-reproduction")?;
    println!("molerat endpoint running, discovery key in ~/.cache/molerat/mcp.key");

    loop {
        molerat.publish(|ui| {
            ui.text("status", "ratz included");
            ui.command("ping", "pingin", || Message::Ping);
        });
        for mess in molerat.messages() {
            println!("received {mess:?}");
        }
        thread::sleep(Duration::from_millis(200));
    }
}
