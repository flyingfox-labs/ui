import gleam/string
import gleam/list

pub fn classes(parts: List(String)) -> String {
  parts |> list.filter(fn(part) { part != ""}) |> string.join(" ")
}