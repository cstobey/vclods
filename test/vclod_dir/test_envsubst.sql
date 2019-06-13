SELECT '$LOG_BASE_DIR'; # enviornment variable substitution should work (substitue the string)
SELECT '${LOG_BASE_DIR}'; # brace guarding should work (substitue the string)
SELECT '$(env)'; # command substitution should not work (do nothing)
SELECT '${LOG_BASE_DIR/\./}'; # parameter expansion should not work (do nothing)
SELECT '$THIS_ENV_VAR_SHOULD_NOT_EXIST'; # unset variables show up blank, so force a default or make sure blank is fine.
