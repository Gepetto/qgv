######################
#
#    Copyright (C) 2014 EngSaS - Engineering Solutions and Services Langenbach. All rights reserved.
#    Copyright (C) 2020-2021 CNRS - Guilhem Saurel
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
######################

CMAKE_MINIMUM_REQUIRED(VERSION 3.1)

SET(PROJECT_NAME qgv)
SET(PROJECT_DESCRIPTION "Interactive Qt graphViz display")
SET(PROJECT_URL "https://github.com/Gepetto/qgv")

SET(PROJECT_USE_CMAKE_EXPORT TRUE)
SET(CXX_DISABLE_WERROR TRUE)

INCLUDE(cmake/base.cmake)
INCLUDE(cmake/boost.cmake)

COMPUTE_PROJECT_ARGS(PROJECT_ARGS LANGUAGES CXX)
PROJECT(${PROJECT_NAME} ${PROJECT_ARGS})

# Extending the Module path with the local module path of desuto
SET(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake_modules/modules )

OPTION(BINDINGS_QT4 "Build with Qt4" OFF)
OPTION(BINDINGS_QT5 "Build with Qt5" OFF)

IF(NOT BINDINGS_QT4 AND NOT BINDINGS_QT5)
  MESSAGE(STATUS "Trying to autodetect Qt version")
  FIND_PACKAGE(Qt5 COMPONENTS Core Widgets LinguistTools QUIET)
  IF(Qt5_FOUND OR QT5_FOUND)
    SET(BINDINGS_QT5 ON)
    MESSAGE(STATUS "Found Qt5 --> Prefer Qt5 over Qt4")
  ELSE(Qt5_FOUND OR QT5_FOUND)
    SET(BINDINGS_QT4 ON)
    MESSAGE(STATUS "Qt5 not found --> Try to build with Qt4")
  ENDIF(Qt5_FOUND OR QT5_FOUND)
ENDIF(NOT BINDINGS_QT4 AND NOT BINDINGS_QT5)

IF(BINDINGS_QT4)
  IF(BINDINGS_QT5)
    MESSAGE(STATUS "Qt4 and Qt5 enabled --> Preferring Qt5 and therefore disabling Qt4")
    SET(BINDINGS_QT4  OFF)
  ELSE(BINDINGS_QT5)
    # Qt4 must be included after setting the build type
    FIND_PACKAGE(Qt4 REQUIRED)
  ENDIF(BINDINGS_QT5)
ENDIF(BINDINGS_QT4)

IF(BINDINGS_QT5)
  FIND_PACKAGE(Qt5 COMPONENTS Core Widgets LinguistTools REQUIRED)
  # Do not automatically link against qtmain
  CMAKE_POLICY(SET CMP0020 OLD)
ENDIF(BINDINGS_QT5)
# enable automatic moc by CMAKE
SET(CMAKE_AUTOMOC ON)

IF(NOT KDE)
	IF(NOT APPLE)
		SET(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,--no-undefined")
	ENDIF(NOT APPLE)
	IF(MSVC)
		SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DQT_NO_EXCEPTIONS -Zc:wchar_t-")
	ELSE(MSVC)
		SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wnon-virtual-dtor -Wno-long-long -Wundef -Wcast-align -Wchar-subscripts -Wall -W -Wpointer-arith -Wformat-security -fno-exceptions -DQT_NO_EXCEPTIONS -fno-check-new -fno-common")
	ENDIF(MSVC)
	IF(NOT WIN32 AND NOT APPLE)
#		SET(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,--fatal-warnings -lc -Wl,--disable-auto-import")
		SET(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,--fatal-warnings -lc")
	ENDIF(NOT WIN32 AND NOT APPLE)
ENDIF(NOT KDE)

ADD_DEFINITIONS(${QT_DEFINITIONS})
FIND_PACKAGE(Graphviz REQUIRED)

######################
#
# include source tree
#
######################

SET(${PROJECT_NAME}_HEADERS
  QGVCore/QGVEdge.h
  QGVCore/qgv.h
  QGVCore/QGVNode.h
  QGVCore/QGVScene.h
  QGVCore/QGVSubGraph.h
)

ADD_SUBDIRECTORY(QGVCore)
ADD_SUBDIRECTORY(Sample EXCLUDE_FROM_ALL)
ADD_SUBDIRECTORY(doc)

# Hack for pkg-config
SET (_PKG_CONFIG_INCLUDEDIR "${_PKG_CONFIG_INCLUDEDIR}/QGVCore")
PKG_CONFIG_APPEND_LIBS("qgvcore")
