///|
struct Dfs[A] {
  graph : Graph[A]
  stack : Array[Int]
  visited : FixedArray[Bool]
}

///|
pub fn Dfs::on[A](graph : Graph[A]) -> Dfs[A] {
  { graph, stack: [], visited: FixedArray::make(graph.node_count(), false) }
}

///|
pub fn Dfs::visited[A](self : Dfs[A], id : Int) -> Bool {
  self.visited[id]
}

///|
pub fn Dfs::at[A](self : Dfs[A], start : Int) -> Iter[Int] {
  Iter::new(fn(yield_) {
    let { graph: { edges, .. }, stack: st, visited: vis } = self
    if not(vis[start]) {
      st.push(start)
      vis[start] = true
    }
    while st.pop() is Some(cur) {
      guard yield_(cur) is IterContinue else {
        st.each(fn(id) { vis[id] = false })
        st.clear()
        return IterEnd
      }
      for next in edges[cur] {
        if not(vis[next]) {
          st.push(next)
          vis[next] = true
        }
      }
    }
    IterContinue
  })
}

///|
pub fn Dfs::at_all[A](self : Dfs[A]) -> Iter[Int] {
  Iter::new(fn(yield_) {
    let { graph: { edges, .. }, stack: st, visited: vis } = self
    for start in 0..<edges.length() {
      if not(vis[start]) {
        st.push(start)
        vis[start] = true
      }
      while st.pop() is Some(cur) {
        // No need to clear st and restore vis
        guard yield_(cur) is IterContinue else { return IterEnd }
        for next in edges[cur] {
          if not(vis[next]) {
            st.push(next)
            vis[next] = true
          }
        }
      }
    }
    IterContinue
  })
}

///|
test "dfs all" {
  let g = Graph::make(5, ())
  let edges = [(0, 1), (1, 3), (0, 2), (2, 3), (3, 1)]
  for e in edges {
    g.add_edge(e.0, e.1)
  }
  inspect!(g.dfs().at_all(), content="[0, 2, 3, 1, 4]")
}

///|
test "dfs at vis" {
  let g = Graph::make(5, ())
  let edges = [(0, 1), (1, 3), (0, 2), (2, 3), (3, 1)]
  for e in edges {
    g.add_edge(e.0, e.1)
  }
  let d = g.dfs()
  inspect!(d.at(2), content="[2, 3, 1]")
  let nodes = (0).until(5)
  inspect!(nodes.map(d.visited(_)), content="[false, true, true, true, false]")
  inspect!(d.at(1), content="[]")
  inspect!(nodes.map(d.visited(_)), content="[false, true, true, true, false]")
  inspect!(d.at(0), content="[0]")
  inspect!(nodes.map(d.visited(_)), content="[true, true, true, true, false]")
}

///|
test "dfs break" {
  let g = Graph::make(5, ())
  let edges = [(0, 1), (1, 3), (0, 2), (2, 3), (3, 1)]
  for e in edges {
    g.add_edge(e.0, e.1)
  }
  let d = g.dfs()
  let nodes = (0).until(5)
  inspect!(d.at(0).take_while(fn(x) { x != 3 }), content="[0, 2]")
  inspect!(nodes.map(d.visited(_)), content="[true, false, true, true, false]")
  inspect!(d.at_all(), content="[1, 4]")
  inspect!(nodes.map(d.visited(_)), content="[true, true, true, true, true]")
}

///|
struct Bfs[A] {
  graph : Graph[A]
  deque : @deque.T[Int]
  visited : FixedArray[Bool]
}

///|
pub fn Bfs::on[A](graph : Graph[A]) -> Bfs[A] {
  {
    graph,
    deque: @deque.new(),
    visited: FixedArray::make(graph.node_count(), false),
  }
}

///|
pub fn Bfs::visited[A](self : Bfs[A], id : Int) -> Bool {
  self.visited[id]
}

///|
pub fn Bfs::at[A](self : Bfs[A], start : Int) -> Iter[Int] {
  Iter::new(fn(yield_) {
    let { graph: { edges, .. }, deque: dq, visited: vis } = self
    if not(vis[start]) {
      dq.push_front(start)
      vis[start] = true
    }
    while dq.pop_back() is Some(cur) {
      guard yield_(cur) is IterContinue else {
        dq.each(fn(id) { vis[id] = false })
        dq.clear()
        return IterEnd
      }
      for next in edges[cur] {
        if not(vis[next]) {
          dq.push_front(next)
          vis[next] = true
        }
      }
    }
    IterContinue
  })
}

///|
pub fn Bfs::at_all[A](self : Bfs[A]) -> Iter[Int] {
  Iter::new(fn(yield_) {
    let { graph: { edges, .. }, deque: dq, visited: vis } = self
    for start in 0..<edges.length() {
      if not(vis[start]) {
        dq.push_front(start)
        vis[start] = true
      }
      while dq.pop_back() is Some(cur) {
        // No need to clear dq and restore vis
        guard yield_(cur) is IterContinue else { return IterEnd }
        for next in edges[cur] {
          if not(vis[next]) {
            dq.push_front(next)
            vis[next] = true
          }
        }
      }
    }
    IterContinue
  })
}

///|
test "bfs all" {
  let g = Graph::make(5, ())
  let edges = [(0, 1), (1, 3), (0, 2), (2, 3), (3, 1)]
  for e in edges {
    g.add_edge(e.0, e.1)
  }
  inspect!(g.bfs().at_all(), content="[0, 1, 2, 3, 4]")
}

///|
test "bfs at vis" {
  let g = Graph::make(5, ())
  let edges = [(0, 1), (1, 3), (0, 2), (2, 3), (3, 1)]
  for e in edges {
    g.add_edge(e.0, e.1)
  }
  let d = g.bfs()
  inspect!(d.at(2), content="[2, 3, 1]")
  let nodes = (0).until(5)
  inspect!(nodes.map(d.visited(_)), content="[false, true, true, true, false]")
  inspect!(d.at(1), content="[]")
  inspect!(nodes.map(d.visited(_)), content="[false, true, true, true, false]")
  inspect!(d.at(0), content="[0]")
  inspect!(nodes.map(d.visited(_)), content="[true, true, true, true, false]")
}

///|
test "bfs break" {
  let g = Graph::make(5, ())
  let edges = [(0, 1), (1, 3), (0, 2), (2, 3), (3, 1)]
  for e in edges {
    g.add_edge(e.0, e.1)
  }
  let d = g.bfs()
  let nodes = (0).until(5)
  inspect!(d.at(0).take_while(fn(x) { x != 2 }), content="[0, 1]")
  inspect!(nodes.map(d.visited(_)), content="[true, true, true, false, false]")
  inspect!(d.at_all(), content="[3, 4]")
  inspect!(nodes.map(d.visited(_)), content="[true, true, true, true, true]")
}
