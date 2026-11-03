extends GutTest
## Teste de exemplo (T00): confirma que o GUT roda sem tela.


func test_gut_esta_funcionando() -> void:
	assert_eq(1 + 1, 2, "O GUT deve executar e passar este teste.")
