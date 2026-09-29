import gleam/fetch
import gleam/http/request
import gleam/int
import gleam/io
import gleam/javascript/promise.{type Promise}
import gleam/result
import shared

pub const stylesheet_url = "https://raw.githubusercontent.com/flyingfox-labs/ui/main/ui_web/src/ui.css"

pub fn main() {
  let outcome = case shared.output_path() {
    Error(message) -> promise.resolve(Error(message))
    Ok(path) -> {
      use body <- promise.map_try(download())
      shared.save(path, body) |> result.replace(path)
    }
  }

  use outcome <- promise.tap(outcome)
  case outcome {
    Ok(path) -> io.println("Wrote " <> path)
    Error(message) -> io.println_error(message)
  }
}

fn download() -> Promise(Result(String, String)) {
  let assert Ok(req) = request.to(stylesheet_url)

  fetch.send(req)
  |> promise.try_await(fetch.read_text_body)
  |> promise.map(fn(result) {
    case result {
      Ok(resp) if resp.status == 200 -> Ok(resp.body)
      Ok(resp) -> Error("Request failed with status " <> int.to_string(resp.status))
      Error(_) -> Error("Download failed")
    }
  })
}