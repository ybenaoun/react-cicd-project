import { render, screen } from '@testing-library/react';
import App from './App';

test('renders CI/CD Pipeline heading', () => {
  render(<App />);
  const headingElement = screen.getByText(/React CI\/CD Pipeline/i);
  expect(headingElement).toBeInTheDocument();
});

test('displays version information', () => {
  render(<App />);
  const versionLabel = screen.getByText(/Version:/i);
  expect(versionLabel).toBeInTheDocument();
});

test('shows healthy status', () => {
  render(<App />);
  const statusElement = screen.getByText(/Healthy/i);
  expect(statusElement).toBeInTheDocument();
});