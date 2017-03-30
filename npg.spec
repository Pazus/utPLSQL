[npgstart]
[options]
[metadata]
name: utPLSQL
version: 3.0.0
description: utPLSQL is a Unit Testing framework for Oracle PL/SQL and SQL. The framework follows industry standards and best patterns of modern Unit Testing frameworks like JUnit and RSpec with tight integration with CI engines
[require]
ordbms: ver_le_11_2
privilege: create session
privilege: create sequence
privilege: create procedure
privilege: create type
privilege: create table
privilege: create view
privilege: create synonym
execute: dbms_lock
[files]
readme.md: meta
LICENSE: meta
[npgend]