///|
pub fn[A] Graph::new(capacity~ : Int = 0) -> Graph[A] {
  { datas: Array::new(capacity~), edges: Array::new(capacity~) }
}

///|
pub fn[A] Graph::make(len : Int, elem : A) -> Graph[A] {
  { datas: Array::make(len, elem), edges: Array::makei(len, _ => []) }
}

///|
pub fn[A] Graph::from_datas(datas : Array[A]) -> Graph[A] {
  { datas, edges: datas.map(_ => []) }
}

///|
pub fn[A] push(self : Graph[A], data : A) -> Int {
  self.edges.push([])
  self.datas.push(data)
  self.datas.length() - 1
}

///| require: id is valid
pub fn[A] data(self : Graph[A], id : Int) -> A {
  self.datas[id]
}

///| require: id is valid
pub fn[A] add_edge(self : Graph[A], from : Int, to : Int) -> Unit {
  self.edges[from].push(to)
}

///| require: id is valid
pub fn[A] add_edge_undirected(self : Graph[A], a : Int, b : Int) -> Unit {
  self.add_edge(a, b)
  self.add_edge(b, a)
}

///|
pub fn[A] has_edge(self : Graph[A], a : Int, b : Int) -> Bool {
  self.edges[a].search(b) is Some(_)
}

///|
pub fn[A] remove_edge(self : Graph[A], a : Int, b : Int) -> Bool {
  let ed = self.edges[a]
  match ed.search(b) {
    Some(index) => {
      ed.remove(index) |> ignore
      true
    }
    None => false
  }
}

///|
pub fn[A] node_count(self : Graph[A]) -> Int {
  self.datas.length()
}

///|
pub fn[A] zip_with(self : Graph[A], iter : Iter[Int]) -> Iter2[Int, A] {
  Iter2::new(yield_ => {
    let datas = self.datas
    iter.run(id => yield_(id, datas[id]))
  })
}

///|
pub fn[A] dfs(self : Graph[A]) -> Dfs[A] {
  Dfs::on(self)
}

///|
pub fn[A] bfs(self : Graph[A]) -> Bfs[A] {
  Bfs::on(self)
}
