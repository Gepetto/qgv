#include "QGVGraphPrivate.h"

QGVGraphPrivate::QGVGraphPrivate(Agraph_t *graph) : _graph(NULL) {
  setGraph(graph);
}

void QGVGraphPrivate::setGraph(Agraph_t *graph) {
  if (_graph != NULL) agclose(_graph);
  _graph = graph;
}

Agraph_t *QGVGraphPrivate::graph() const { return _graph; }
