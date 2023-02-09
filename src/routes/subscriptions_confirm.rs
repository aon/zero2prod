use actix_web::{web, HttpResponse};
use serde::Deserialize;

#[derive(Deserialize)]
pub struct Parameters {
    subscription_token: String,
}

#[tracing::instrument(name = "Confirming a pending subscriber", skip(parameters))]
pub async fn confirm(parameters: web::Query<Parameters>) -> HttpResponse {
    HttpResponse::Ok().finish()
}
