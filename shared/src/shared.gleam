import argv
import filepath
import gleam/result
import simplifile

pub fn output_path() -> Result(String, String) {
  case argv.load().arguments {
    [path] -> Ok(path)
    _ -> Error("Usage: gleam run -m dev/style -- <path>")
  }
}

pub fn save(path: String, contents: String) -> Result(Nil, String) {
  use _ <- result.try(
    simplifile.create_directory_all(filepath.directory_name(path))
    |> result.map_error(simplifile.describe_error),
  )
  simplifile.write(to: path, contents: contents)
  |> result.map_error(simplifile.describe_error)
}