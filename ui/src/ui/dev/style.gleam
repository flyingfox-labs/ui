import gleam/http/request
import gleam/httpc
import gleam/int
import gleam/io
import gleam/result
import shared

pub fn main() {
  case sync() {
    Ok(path) -> io.println("Wrote " <> path)
    Error(message) -> io.println_error(message)
  }
}

fn sync() -> Result(String, String) {
  use path <- result.try(shared.output_path())
  use body <- result.try(download())
  use _ <- result.try(shared.save(path, body))
  Ok(path)
}

fn download() -> Result(String, String) {
  let assert Ok(req) = request.to(shared.stylesheet_url)
  let config =
    httpc.configure()
    |> httpc.follow_redirects(True)
    |> httpc.timeout(30_000)

  case httpc.dispatch(config, req) {
    Ok(resp) if resp.status == 200 -> Ok(resp.body)
    Ok(resp) -> Error("Request failed with status " <> int.to_string(resp.status))
    Error(_) -> Error("Download failed")
  }
}