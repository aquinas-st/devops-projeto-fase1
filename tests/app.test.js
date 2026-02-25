const request = require('supertest');
const app = require('../src/app');

describe('API DevOps - Fase 1', () => {

  // Testa a rota principal
  describe('GET /', () => {
    it('deve retornar informações do projeto', async () => {
      const res = await request(app).get('/');
      expect(res.statusCode).toBe(200);
      expect(res.body).toHaveProperty('projeto');
      expect(res.body).toHaveProperty('status', 'ativo');
      expect(res.body).toHaveProperty('versao', '1.0.0');
    });
  });

  // Testa a rota de health check
  describe('GET /health', () => {
    it('deve retornar status ok', async () => {
      const res = await request(app).get('/health');
      expect(res.statusCode).toBe(200);
      expect(res.body).toHaveProperty('status', 'ok');
      expect(res.body).toHaveProperty('timestamp');
    });
  });

  // Testa a rota de informações
  describe('GET /info', () => {
    it('deve retornar as tecnologias utilizadas', async () => {
      const res = await request(app).get('/info');
      expect(res.statusCode).toBe(200);
      expect(res.body).toHaveProperty('tecnologias');
      expect(res.body.tecnologias).toHaveProperty('runtime', 'Node.js');
      expect(res.body.tecnologias).toHaveProperty('ci', 'GitHub Actions');
      expect(res.body.tecnologias).toHaveProperty('iac', 'Terraform');
      expect(res.body).toHaveProperty('fase', 1);
    });
  });

  // Testa a listagem de tarefas
  describe('GET /tarefas', () => {
    it('deve retornar a lista de tarefas', async () => {
      const res = await request(app).get('/tarefas');
      expect(res.statusCode).toBe(200);
      expect(res.body).toHaveProperty('total');
      expect(res.body).toHaveProperty('tarefas');
      expect(Array.isArray(res.body.tarefas)).toBe(true);
      expect(res.body.total).toBeGreaterThan(0);
    });
  });

  // Testa buscar tarefa por ID
  describe('GET /tarefas/:id', () => {
    it('deve retornar uma tarefa específica', async () => {
      const res = await request(app).get('/tarefas/1');
      expect(res.statusCode).toBe(200);
      expect(res.body).toHaveProperty('id', 1);
      expect(res.body).toHaveProperty('titulo');
      expect(res.body).toHaveProperty('concluida');
    });

    it('deve retornar 404 para tarefa inexistente', async () => {
      const res = await request(app).get('/tarefas/999');
      expect(res.statusCode).toBe(404);
      expect(res.body).toHaveProperty('erro');
    });
  });

  // Testa criação de tarefa
  describe('POST /tarefas', () => {
    it('deve criar uma nova tarefa', async () => {
      const res = await request(app)
        .post('/tarefas')
        .send({ titulo: 'Nova tarefa de teste' });
      expect(res.statusCode).toBe(201);
      expect(res.body).toHaveProperty('titulo', 'Nova tarefa de teste');
      expect(res.body).toHaveProperty('concluida', false);
    });

    it('deve retornar erro 400 sem título', async () => {
      const res = await request(app)
        .post('/tarefas')
        .send({});
      expect(res.statusCode).toBe(400);
      expect(res.body).toHaveProperty('erro');
    });
  });

});
