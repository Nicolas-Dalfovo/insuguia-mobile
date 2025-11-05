import re

with open('/home/ubuntu/page_texts/diretriz.diabetes.org.br_manejo-da-hiperglicemia-hospitalar-em-pacientes-nao-criticos_.md', 'r', encoding='utf-8') as f:
    content = f.read()

# Extrair tabelas
tables = re.findall(r'(TABELA \d+:.*?)(?=TABELA \d+:|QUADRO \d+:|Recomendações|NOTA IMPORTANTE|$)', content, re.DOTALL)

with open('/home/ubuntu/insuguia_app/docs/tabelas_extraidas.txt', 'w', encoding='utf-8') as f:
    for i, table in enumerate(tables, 1):
        f.write(f"\n{'='*80}\n")
        f.write(f"TABELA {i}\n")
        f.write(f"{'='*80}\n")
        f.write(table.strip())
        f.write("\n\n")

print(f"Extraídas {len(tables)} tabelas")
