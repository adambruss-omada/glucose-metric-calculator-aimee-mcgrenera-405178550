import React from 'react'
import ReactDOM from 'react-dom/client'
import MetricsDashboard from './components/glucose_dashboard/metrics'

const App = () => {
  return (
    <div>
      <h1>Glucose Metrics Calculator</h1>
      <MetricsDashboard />
    </div>
  )
}

document.addEventListener('DOMContentLoaded', () => {
  const root = ReactDOM.createRoot(document.getElementById('root'))
  root.render(<App />)
}) 