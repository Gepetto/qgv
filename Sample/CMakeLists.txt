# enable all QT-Stuff we need see
# http://cmake.org/cmake/help/cmake2.6docs.html#module:FindQt4 for a complete
# list

set(qgv_TS)

set(qgv_UI MainWindow.ui)

# all files which may be mocced
set(qgv_CPP main.cpp MainWindow.cpp QGraphicsViewEc.cpp)

if(BINDINGS_QT4)
  # include with QT_USE selected library parts
  include(${QT_USE_FILE})
endif(BINDINGS_QT4)

include_directories(${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_CURRENT_SOURCE_DIR})

if(BINDINGS_QT4)
  # make *.h out of *.ui
  qt4_wrap_ui(qgv_UI_H ${qgv_UI})

  # moc classes
  qt4_automoc(${qgv_CPP})

  # add translations
  qt4_add_translation(qgv_TRANS ${qgv_TS})
else(BINDINGS_QT4)
  # make *.h out of *.ui
  qt5_wrap_ui(qgv_UI_H ${qgv_UI})

  # add translations
  qt5_add_translation(qgv_TRANS ${qgv_TS})
endif(BINDINGS_QT4)

set(neededStuff ${qgv_CPP} ${qgv_UI_H} ${qgv_TRANS})

if(UNIX)
  add_executable(sample ${neededStuff})
elseif(APPLE)
  # it's with gui, so MACOSX_BUNDLE is needed
  add_executable(sample MACOSX_BUNDLE ${neededStuff})
elseif(WIN32)
  # it's with gui, so WIN32 is needed
  add_executable(sample WIN32 ${neededStuff})
endif()
set_target_properties(sample PROPERTIES OUTPUT_NAME "Sample")

target_link_libraries(sample qgvcore)
target_include_directories(
  qgvcore PUBLIC $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/QGVCore>
                 $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/QGVCore>)
if(BINDINGS_QT4)
  target_link_libraries(sample ${QT_LIBRARIES})
endif(BINDINGS_QT4)
if(BINDINGS_QT5)
  target_link_libraries(sample Qt5::Core Qt5::Widgets)
  set(CMAKE_AUTOMOC ON)
endif(BINDINGS_QT5)
