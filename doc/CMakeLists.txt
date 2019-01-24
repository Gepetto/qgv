# Copyright (c) 2019 CNRS
# Author: Joseph Mirabel

# {{{ Find Qt tags
SET(_use_qt_local_doc FALSE)
SET(qt_online_doc "http://doc.qt.io")

IF(BINDINGS_QT4)
  FIND_FILE(QT4_TAGFILE doc/html/qt.tags
    HINTS / /usr
    PATH_SUFFIXES share/qt4)
  # Eventually, QT4_TAGFILE can be set manually to
  # /usr/share/qt4/doc/html/qt.tags
  # on ubuntu 16.04, from package qt4-doc-html
  IF(QT4_TAGFILE)
    IF(_use_qt_local_doc)
      GET_FILENAME_COMPONENT(path_to_doc ${QT4_TAGFILE} DIRECTORY)
      SET(QT_TAGFILES "\"${QT4_TAGFILE}=${path_to_doc}\"" PARENT_SCOPE)
    ELSE(_use_qt_local_doc)
      SET(QT_TAGFILES "\"${QT4_TAGFILE}=${qt_doc}/archives/qt-4.8\"" PARENT_SCOPE)
    ENDIF(_use_qt_local_doc)
  ENDIF()
ELSE(BINDINGS_QT4)
  SET(_QT_TAGFILES)
  # Available components
  # qtcore qtgui qtwidgets qtnetwork qtsql
  # qtprintsupport qttestlib qtconcurrent qdoc qtxml
  FOREACH (component "core" "widgets" "gui")
    STRING(TOUPPER ${component} _up_comp)
    FIND_FILE(QT5_${_up_comp}_TAGFILE doc/qt${component}/qt${component}.tags
      HINTS / /usr
      PATH_SUFFIXES share/qt5)
    # Eventually, QT5_${_up_comp}_TAGFILE can be set manually to
    # /usr/share/qt5/doc/qt${component}/qt${component}.tags
    # on ubuntu 16.04, from package qtbase5-doc-html
    IF(QT5_${_up_comp}_TAGFILE)
      IF(_use_qt_local_doc)
        GET_FILENAME_COMPONENT(path_to_doc ${QT5_${_up_comp}_TAGFILE} DIRECTORY)
        SET(_QT_TAGFILES "${_QT_TAGFILES} \"${QT5_${_up_comp}_TAGFILE}=${path_to_doc}\"")
      ELSE(_use_qt_local_doc)
        SET(_QT_TAGFILES "${_QT_TAGFILES} \"${QT5_${_up_comp}_TAGFILE}=${qt_doc}/qt-5\"")
      ENDIF(_use_qt_local_doc)
    ENDIF()
  ENDFOREACH()
  SET(QT_TAGFILES ${_QT_TAGFILES} PARENT_SCOPE)
ENDIF(BINDINGS_QT4)
# }}}

# vim: foldmethod=marker foldlevel=0
