# enable all QT-Stuff we need see
# http://cmake.org/cmake/help/cmake2.6docs.html#module:FindQt4 for a complete
# list

set(qgvlib_TS)

set(qgvlib_UI)

# all files which may be mocced
set(qgvlib_CPP
    private/QGVCore.cpp
    private/QGVGraphPrivate.cpp
    private/QGVEdgePrivate.cpp
    private/QGVGvcPrivate.cpp
    private/QGVNodePrivate.cpp
    QGVEdge.cpp
    QGVNode.cpp
    QGVScene.cpp
    QGVSubGraph.cpp)

set(TARGET_NAME "QGVCore")

include_directories(
  ${Graphviz_INCLUDE_DIR} ${CMAKE_CURRENT_BINARY_DIR}
  ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/private
  ${CMAKE_CURRENT_BINARY_DIR}/private)
# Activate Export macro for building the library itself if QGVCORE_LIB is not
# set or equal 0 (null), import macro is used
add_definitions(-DQGVCORE_LIB)

if(BINDINGS_QT4)
  # QT5 does not declare and does not need QT_INCLUDES
  set(INCLUDE_DIRECTORIES ${INCLUDES_DIRECTORIES} ${QT_INCLUDES})
  # include with QT_USE selected library parts
  include(${QT_USE_FILE})
endif(BINDINGS_QT4)
add_definitions(-DQVGCORE_LIB)

if(BINDINGS_QT4)
  qt4_automoc(${qgvlib_CPP})
  qt4_wrap_ui(qgvlib_UI_H ${qgvlib_UI})
  qt4_add_translation(qgvlib_TRANS ${qgvlib_TS})
  # -binary is not working QT4_ADD_RESOURCES(RCCS "${QRCS}" OPTIONS "-binary")
  # QT4_ADD_RESOURCES(qgvlib_RCCS ${qgvlib_QRC})
endif(BINDINGS_QT4)
if(BINDINGS_QT5)
  qt5_wrap_ui(qgvlib_UI_H ${qgvlib_UI})
  qt5_add_translation(qgvlib_TRANS ${qgvlib_TS})
  qt5_add_resources(qgvlib_RCCS ${qgvlib_QRC})
endif(BINDINGS_QT5)

add_library(qgvcore SHARED ${qgvlib_CPP} ${qgvlib_UI_H} ${qgvlib_TRANS})

target_link_libraries(qgvcore PUBLIC ${Graphviz_LIBRARIES})

target_include_directories(
  qgvcore PUBLIC $<INSTALL_INTERFACE:"${CMAKE_INSTALL_INCLUDEDIR}/QGVCore">)

if(BINDINGS_QT4)
  target_link_libraries(qgvcore PUBLIC ${QT_LIBRARIES})
endif(BINDINGS_QT4)
if(BINDINGS_QT5)
  target_link_libraries(qgvcore PUBLIC Qt5::Core Qt5::Widgets)
endif(BINDINGS_QT5)

if(WIN32)
  # this extra install command is needed by the nsis installer
  install(TARGETS qgvcore RUNTIME DESTINATION lib COMPONENT library)
else(WIN32)
  install(
    TARGETS qgvcore
    EXPORT ${TARGETS_EXPORT_NAME}
    DESTINATION lib
    COMPONENT library)
endif(WIN32)

# The COMPONENT option only defines the internal belonging of the INSTALL'ed
# thing INSTALL( FILES ${qgvlib_TRANS} DESTINATION ${qm_DIR} COMPONENT library )

if(WIN32)
  # QuaZip FIND_FILE(PACK_zlib zlib.dll PATHS ${QT_BINARY_DIR} NO_DEFAULT_PATH)
  # INSTALL(FILES ${QUAZIP_LIBRARIES} ${PACK_zlib} DESTINATION ${bin_DIR}
  # COMPONENT library)

  # Qt itself
  find_file(
    PACK_qtcore QtCore4.dll
    PATHS ${QT_BINARY_DIR}
    NO_DEFAULT_PATH)
  find_file(
    PACK_qtgui QtGui4.dll
    PATHS ${QT_BINARY_DIR}
    NO_DEFAULT_PATH)

  find_file(
    PACK_mingwm10 mingwm10.dll
    PATHS ${QT_BINARY_DIR}
    NO_DEFAULT_PATH)
  find_file(
    PACK_libgcc_s_dw libgcc_s_dw2-1.dll
    PATHS ${QT_BINARY_DIR}
    NO_DEFAULT_PATH)

  install(
    FILES ${PACK_qtcore}
          ${PACK_qtgui}
          # ${PACK_qtnetwork} ${PACK_qtsql} ${PACK_libmysql} ${PACK_qtxml}
          # ${PACK_qtxml_patterns}
          ${PACK_mingwm10}
          ${PACK_libgcc_s_dw}
    DESTINATION ${bin_DIR}
    COMPONENT qtlibs)
endif(WIN32)
