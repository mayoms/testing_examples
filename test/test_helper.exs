{:ok, _} = Application.ensure_all_started(:ex_machina)

Mox.defmock(PermissionMock, for: TestingExamples.Permissions)

ExUnit.start()
