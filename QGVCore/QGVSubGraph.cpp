/***************************************************************
QGVCore
Copyright (c) 2014, Bergont Nicolas, All rights reserved.

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 3.0 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library.
***************************************************************/
#include "QGVSubGraph.h"

#include <QGVCore.h>
#include <QGVGraphPrivate.h>
#include <QGVNode.h>
#include <QGVNodePrivate.h>
#include <QGVScene.h>

#include <QDebug>
#include <QPainter>

QGVSubGraph::QGVSubGraph(QGVGraphPrivate *subGraph, QGVScene *scene)
    : _scene(scene), _sgraph(subGraph) {
  // setFlag(QGraphicsItem::ItemIsSelectable, true);
}

QGVSubGraph::~QGVSubGraph() {
  _scene->removeItem(this);
  delete _sgraph;
}

QString QGVSubGraph::name() const {
  return QString::fromLocal8Bit(GD_label(_sgraph->graph())->text);
}

QGVNode *QGVSubGraph::addNode(const QString &label) {
  Agnode_t *node = agnode(_sgraph->graph(), NULL, true);
  if (node == NULL) {
    qWarning() << "Invalid sub node :" << label;
    return 0;
  }
  agsubnode(_sgraph->graph(), node, true);

  QGVNode *item = new QGVNode(new QGVNodePrivate(node), _scene);
  item->setLabel(label);
  _scene->addItem(item);
  _scene->_nodes.append(item);
  _nodes.append(item);
  return item;
}

QGVSubGraph *QGVSubGraph::addSubGraph(const QString &name, bool cluster) {
  Agraph_t *sgraph;
  if (cluster)
    sgraph = agsubg(_sgraph->graph(), ("cluster_" + name).toLocal8Bit().data(),
                    true);
  else
    sgraph = agsubg(_sgraph->graph(), name.toLocal8Bit().data(), true);

  if (sgraph == NULL) {
    qWarning() << "Invalid subGraph :" << name;
    return 0;
  }

  QGVSubGraph *item = new QGVSubGraph(new QGVGraphPrivate(sgraph), _scene);
  _scene->_subGraphs.append(item);
  _scene->addItem(item);
  return item;
}

QRectF QGVSubGraph::boundingRect() const {
  return QRectF(0, 0, _width, _height);
}

void QGVSubGraph::paint(QPainter *painter, const QStyleOptionGraphicsItem *,
                        QWidget *) {
  painter->save();

  painter->setPen(_pen);
  painter->setBrush(_brush);

  painter->drawRect(boundingRect());
  painter->drawText(_label_rect, Qt::AlignCenter, _label);
  painter->restore();
}

void QGVSubGraph::setAttribute(const QString &name, const QString &value) {
  char empty[] = "";
  agsafeset(_sgraph->graph(), name.toLocal8Bit().data(),
            value.toLocal8Bit().data(), empty);
}

QString QGVSubGraph::getAttribute(const QString &name) const {
  char *value = agget(_sgraph->graph(), name.toLocal8Bit().data());
  if (value) return value;
  return QString();
}

void QGVSubGraph::updateLayout() {
  prepareGeometryChange();

  // SubGraph box
  boxf box = GD_bb(_sgraph->graph());
  pointf p1 = box.UR;
  pointf p2 = box.LL;
  _width = p1.x - p2.x;
  _height = p1.y - p2.y;

  qreal gheight = QGVCore::graphHeight(_scene->_graph->graph());
  setPos(p2.x, gheight - p1.y);

  _pen.setWidth(1);
  _brush.setStyle(QGVCore::toBrushStyle(getAttribute("style")));
  _brush.setColor(QGVCore::toColor(getAttribute("fillcolor")));
  _pen.setColor(QGVCore::toColor(getAttribute("color")));

  // SubGraph label
  textlabel_t *xlabel = GD_label(_sgraph->graph());
  if (xlabel) {
    _label = xlabel->text;
    _label_rect.setSize(QSize(xlabel->dimen.x, xlabel->dimen.y));
    _label_rect.moveCenter(
        QGVCore::toPoint(xlabel->pos,
                         QGVCore::graphHeight(_scene->_graph->graph())) -
        pos());
  }
}
