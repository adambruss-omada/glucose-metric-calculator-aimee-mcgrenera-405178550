import React, { useState } from 'react';

function MetricsDashboard() {
  const [memberId, setMemberId] = useState('');
  const [period, setPeriod] = useState('last_7_days');
  const [metrics, setMetrics] = useState(null);
  const [error, setError] = useState(null);


  const fetchMetrics = async () => {
    try {
      const res = await fetch(`/api/v1/metrics?member_id=${memberId}&period=${period}`);
      const data = await res.json();

      if (!res.ok) throw new Error(data.error || 'Error fetching metrics');
      setMetrics(data.metrics);
      setError(null);
    } catch (err) {
      setMetrics(null);
      setError(err.message);
    }
  };

  return (
    <div className="dashboard">
      <div>
        <label>
          Member ID:
          <input type="number" value={memberId} onChange={e => setMemberId(e.target.value)} />
        </label>

        <br />
        <label>
          Time Frame:
          <select value={period} onChange={e => setPeriod(e.target.value)}>
            <option value="last_7_days">Last 7 Days</option>
            <option value="previous_week">Last Week</option>
            <option value="this_month">This Month</option>
            <option value="last_month">Last Month</option>
          </select>
        </label>

        <button onClick={fetchMetrics}>Calculate</button>
      </div>

      {error && <p style={{ color: 'red' }}>{error}</p>}

      {metrics && (
        <div className="results">
          <h2>Metrics</h2>
          <ul>
            <li><strong>Average:</strong> {metrics.average}</li>
            <li><strong>Above Range (%):</strong> {metrics.above_range}</li>
            <li><strong>Below Range (%):</strong> {metrics.below_range}</li>
            <li><strong>Count:</strong> {metrics.count}</li>
            <li><strong>Change from previous period:</strong> {metrics.changes}</li>
          </ul>
        </div>
      )}
    </div>
  );
}

export default MetricsDashboard;