import os
from create_database_utils import *
from diagnostics_test_utils import *

run_codeql_database_create([], lang="ruby", runFunction = runSuccessfully, db = None)

check_diagnostics()
