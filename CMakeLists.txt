cmake_minimum_required(VERSION 3.29)
set(PROJECT_NAME $ENV{PN})
set(MAIN_TARGET_NAME ${PROJECT_NAME})

project(${PROJECT_NAME} LANGUAGES Swift)

add_executable(${MAIN_TARGET_NAME} 
    main.swift
    moar.swift
)