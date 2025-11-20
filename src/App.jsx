import React from 'react';
import './App.css';

function App() {
  const version = process.env.REACT_APP_VERSION || 'dev';
  const buildDate = new Date().toISOString();

  return (
    <div className="App">
      <header className="App-header">
        <h1>🚀 React CI/CD Pipeline</h1>
        <div className="info-container">
          <div className="info-card">
            <span className="label">Version:</span>
            <span className="value">{version}</span>
          </div>
          <div className="info-card">
            <span className="label">Build Date:</span>
            <span className="value">{buildDate}</span>
          </div>
          <div className="info-card">
            <span className="label">Environment:</span>
            <span className="value">{process.env.NODE_ENV}</span>
          </div>
        </div>
        
        <div className="features">
          <h2>✨ Pipeline Features</h2>
          <ul>
            <li>✅ Build & Smoke Test on PR</li>
            <li>✅ Complete Build on Dev Push</li>
            <li>✅ Versioned Release Build</li>
            <li>✅ Docker Multi-Stage Build</li>
            <li>✅ Parallel Node.js Builds</li>
            <li>✅ Automated Smoke Tests</li>
          </ul>
        </div>

        <div className="status">
          <span className="status-badge success">✓ Healthy</span>
        </div>
      </header>
    </div>
  );
}

export default App;