(lang dune 3.7)

(name lisboot)

(generate_opam_files true)

(source
 (github dannypsnl/lisboot))

(authors "dannypsnl")

(maintainers "dannypsnl")

(license LICENSE)

(documentation https://url/to/documentation)

(using menhir 2.1)

(package
 (name lisboot)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends ocaml dune)
 (tags
  (topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
