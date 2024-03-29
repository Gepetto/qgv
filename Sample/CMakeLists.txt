# enable all QT-Stuff we need
# see http://cmake.org/cmake/help/cmake2.6docs.html#module:FindQt4 for a complete list

SET(qgv_TS
  )

SET(qgv_UI
  MainWindow.ui
  )

# all files which may be mocced
SET(qgv_CPP
  main.cpp
  MainWindow.cpp
  QGraphicsViewEc.cpp
  )

IF(BINDINGS_QT4)
  # include with QT_USE selected library parts
  INCLUDE(${QT_USE_FILE})
ENDIF(BINDINGS_QT4)

INCLUDE_DIRECTORIES(
  ${CMAKE_CURRENT_BINARY_DIR}
  ${CMAKE_CURRENT_SOURCE_DIR}
  )

IF(BINDINGS_QT4)
  # make *.h out of *.ui
  QT4_WRAP_UI(qgv_UI_H ${qgv_UI})

  # moc classes
  QT4_AUTOMOC(${qgv_CPP})

  # add translations
  QT4_ADD_TRANSLATION(qgv_TRANS ${qgv_TS})
ELSE(BINDINGS_QT4)
  # make *.h out of *.ui
  QT5_WRAP_UI(qgv_UI_H ${qgv_UI})

  # add translations
  QT5_ADD_TRANSLATION(qgv_TRANS ${qgv_TS})
ENDIF(BINDINGS_QT4)

SET(neededStuff
  ${qgv_CPP}
  ${qgv_UI_H}
  ${qgv_TRANS}
  )

IF(UNIX)
  ADD_EXECUTABLE(sample ${neededStuff})
ELSEIF(APPLE)
  # it's with gui, so MACOSX_BUNDLE is needed
  ADD_EXECUTABLE(sample MACOSX_BUNDLE ${neededStuff})
ELSEIF(WIN32)
  # it's with gui, so WIN32 is needed
  ADD_EXECUTABLE(sample WIN32 ${neededStuff})
ENDIF()
SET_TARGET_PROPERTIES(sample PROPERTIES
  OUTPUT_NAME "Sample")

TARGET_LINK_LIBRARIES(sample qgvcore)
TARGET_INCLUDE_DIRECTORIES(qgvcore PUBLIC
  $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/QGVCore>
  $<INSTALL_INTERFACE:include/QGVCore>)
IF(BINDINGS_QT4)
  TARGET_LINK_LIBRARIES(sample ${QT_LIBRARIES})
ENDIF(BINDINGS_QT4)
IF(BINDINGS_QT5)
  TARGET_LINK_LIBRARIES(sample Qt5::Core Qt5::Widgets)
  SET(CMAKE_AUTOMOC ON)
ENDIF(BINDINGS_QT5)
