use zero2prod::{startup::run, configuration::get_configuration};

#[tokio::main]
async fn main() -> std::io::Result<()> {
    let configuration = get_configuration().expect("Failed to read configuration.");
    let listener = std::net::TcpListener::bind(format!("127.0.0.1:{}", configuration.application_port))?;
    run(listener)?.await
}
