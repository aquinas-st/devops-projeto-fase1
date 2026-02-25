const express = require('express');
const app = express();

app.use(express.json());

// Rota principal
app.get('/', (req, res) => {
  res.json({
    projeto: 'DevOps na Prática - Fase 1',
    descricao: 'API REST para demonstração de CI/CD e IaC',
    versao: '1.0.0',
    status: 'ativo'
  });
});

// Rota de health check
app.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    timestamp: new Date().toISOString()
  });
});

// Rota de informações do projeto
app.get('/info', (req, res) => {
  res.json({
    tecnologias: {
      runtime: 'Node.js',
      framework: 'Express',
      testes: 'Jest',
      ci: 'GitHub Actions',
      iac: 'Terraform',
      cloud: 'AWS'
    },
    fase: 1,
    etapa: 'Configuração e Automação Inicial'
  });
});

// Rota para listar tarefas (exemplo CRUD simples)
let tarefas = [
  { id: 1, titulo: 'Configurar repositório GitHub', concluida: true },
  { id: 2, titulo: 'Implementar pipeline CI', concluida: true },
  { id: 3, titulo: 'Criar scripts Terraform', concluida: true }
];

app.get('/tarefas', (req, res) => {
  res.json({ total: tarefas.length, tarefas });
});

app.get('/tarefas/:id', (req, res) => {
  const tarefa = tarefas.find(t => t.id === parseInt(req.params.id));
  if (!tarefa) {
    return res.status(404).json({ erro: 'Tarefa não encontrada' });
  }
  res.json(tarefa);
});

app.post('/tarefas', (req, res) => {
  const { titulo } = req.body;
  if (!titulo) {
    return res.status(400).json({ erro: 'O campo título é obrigatório' });
  }
  const novaTarefa = {
    id: tarefas.length + 1,
    titulo,
    concluida: false
  };
  tarefas.push(novaTarefa);
  res.status(201).json(novaTarefa);
});

// Exporta o app para os testes (sem iniciar o servidor)
module.exports = app;

// Inicia o servidor apenas se executado diretamente
if (require.main === module) {
  const PORT = process.env.PORT || 3000;
  app.listen(PORT, () => {
    console.log(`Servidor rodando na porta ${PORT}`);
    console.log(`Acesse: http://localhost:${PORT}`);
  });
}
