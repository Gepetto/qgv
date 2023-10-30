# ##############################################################################
#
# Copyright (C) 2014 EngSaS - Engineering Solutions and Services Langenbach. All
# rights reserved. Copyright (C) 2020-2021 CNRS - Guilhem Saurel
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program.  If not, see <http://www.gnu.org/licenses/>.
#
# ##############################################################################

cmake_minimum_required(VERSION 3.10)

set(PROJECT_NAME qgv)
set(PROJECT_DESCRIPTION "Interactive Qt graphViz display")
set(PROJECT_URL "https://github.com/Gepetto/qgv")

set(PROJECT_USE_CMAKE_EXPORT TRUE)
set(CXX_DISABLE_WERROR TRUE)

include(cmake/base.cmake)
include(cmake/boost.cmake)

compute_project_args(PROJECT_ARGS LANGUAGES CXX)
project(${PROJECT_NAME} ${PROJECT_ARGS})

# Extending the Module path with the local module path of desuto
set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake_modules/modules)

option(BINDINGS_QT4 "Build with Qt4" OFF)
option(BINDINGS_QT5 "Build with Qt5" OFF)

if(NOT BINDINGS_QT4 AND NOT BINDINGS_QT5)
  message(STATUS "Trying to autodetect Qt version")
  find_package(
    Qt5
    COMPONENTS Core Widgets LinguistTools
    QUIET)
  if(Qt5_FOUND OR QT5_FOUND)
    set(BINDINGS_QT5 ON)
    message(STATUS "Found Qt5 --> Prefer Qt5 over Qt4")
  else(Qt5_FOUND OR QT5_FOUND)
    set(BINDINGS_QT4 ON)
    message(STATUS "Qt5 not found --> Try to build with Qt4")
  endif(Qt5_FOUND OR QT5_FOUND)
endif(NOT BINDINGS_QT4 AND NOT BINDINGS_QT5)

if(BINDINGS_QT4)
  if(BINDINGS_QT5)
    message(
      STATUS
        "Qt4 and Qt5 enabled --> Preferring Qt5 and therefore disabling Qt4")
    set(BINDINGS_QT4 OFF)
  else(BINDINGS_QT5)
    # Qt4 must be included after setting the build type
    find_package(Qt4 REQUIRED)
  endif(BINDINGS_QT5)
endif(BINDINGS_QT4)

if(BINDINGS_QT5)
  find_package(
    Qt5
    COMPONENTS Core Widgets LinguistTools
    REQUIRED)
  # Do not automatically link against qtmain
  cmake_policy(SET CMP0020 OLD)
endif(BINDINGS_QT5)
# enable automatic moc by CMAKE
set(CMAKE_AUTOMOC ON)

if(NOT KDE)
  if(NOT APPLE)
    set(CMAKE_SHARED_LINKER_FLAGS
        "${CMAKE_SHARED_LINKER_FLAGS} -Wl,--no-undefined")
  endif(NOT APPLE)
  if(MSVC)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DQT_NO_EXCEPTIONS -Zc:wchar_t-")
  else(MSVC)
    set(CMAKE_CXX_FLAGS
        "${CMAKE_CXX_FLAGS} -Wnon-virtual-dtor -Wno-long-long -Wundef -Wcast-align -Wchar-subscripts -Wall -W -Wpointer-arith -Wformat-security -fno-exceptions -DQT_NO_EXCEPTIONS -fno-check-new -fno-common"
    )
  endif(MSVC)
  if(NOT WIN32 AND NOT APPLE)
    # SET(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS}
    # -Wl,--fatal-warnings -lc -Wl,--disable-auto-import")
    set(CMAKE_SHARED_LINKER_FLAGS
        "${CMAKE_SHARED_LINKER_FLAGS} -Wl,--fatal-warnings -lc")
  endif(NOT WIN32 AND NOT APPLE)
endif(NOT KDE)

add_definitions(${QT_DEFINITIONS})
find_package(Graphviz REQUIRED)

# ##############################################################################
#
# include source tree
#
# ##############################################################################

set(${PROJECT_NAME}_HEADERS QGVCore/QGVEdge.h QGVCore/qgv.h QGVCore/QGVNode.h
                            QGVCore/QGVScene.h QGVCore/QGVSubGraph.h)

add_subdirectory(QGVCore)
add_subdirectory(Sample EXCLUDE_FROM_ALL)
add_subdirectory(doc)

# Hack for pkg-config
set(_PKG_CONFIG_INCLUDEDIR "${_PKG_CONFIG_INCLUDEDIR}/QGVCore")
pkg_config_append_libs("qgvcore")
