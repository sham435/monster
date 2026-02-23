'use client'

import { useState, useRef, useEffect } from 'react'
import { Send, Code, GitBranch, FileText, Terminal, Settings, MessageSquare } from 'lucide-react'
import io, { Socket } from 'socket.io-client'

interface Message {
  id: string
  type: 'user' | 'assistant'
  content: string
  timestamp: Date
}

export default function MonsterCodeInterface() {
  const [messages, setMessages] = useState<Message[]>([])
  const [input, setInput] = useState('')
  const [isTyping, setIsTyping] = useState(false)
  const [isConnected, setIsConnected] = useState(false)
  const socketRef = useRef<Socket | null>(null)
  const messagesEndRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    // Connect to backend
    const socketInstance = io('http://localhost:3001')

    socketInstance.on('connect', () => {
      setIsConnected(true)
      console.log('Connected to Monster Code backend')
    })

    socketInstance.on('disconnect', () => {
      setIsConnected(false)
      console.log('Disconnected from Monster Code backend')
    })

    socketInstance.on('response', (data) => {
      const assistantMessage: Message = {
        id: Date.now().toString(),
        type: 'assistant',
        content: data.message,
        timestamp: new Date(data.timestamp)
      }
      setMessages(prev => [...prev, assistantMessage])
      setIsTyping(false)
    })

    socketInstance.on('code_response', (data) => {
      const assistantMessage: Message = {
        id: Date.now().toString(),
        type: 'assistant',
        content: `${data.explanation}\n\nSuggestions:\n${data.suggestions.map((s: string) => `• ${s}`).join('\n')}`,
        timestamp: new Date(data.timestamp)
      }
      setMessages(prev => [...prev, assistantMessage])
      setIsTyping(false)
    })

    socketInstance.on('git_response', (data) => {
      const assistantMessage: Message = {
        id: Date.now().toString(),
        type: 'assistant',
        content: `${data.message}\n\nCommands:\n${data.commands.map((cmd: string) => `• ${cmd}`).join('\n')}`,
        timestamp: new Date(data.timestamp)
      }
      setMessages(prev => [...prev, assistantMessage])
      setIsTyping(false)
    })

    socketRef.current = socketInstance

    return () => {
      socketInstance.disconnect()
    }
  }, [])

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' })
  }

  useEffect(() => {
    scrollToBottom()
  })

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!input.trim() || !socketRef.current) return

    const userMessage: Message = {
      id: Date.now().toString(),
      type: 'user',
      content: input,
      timestamp: new Date()
    }

    setMessages(prev => [...prev, userMessage])
    setInput('')
    setIsTyping(true)

    // Send message to backend via WebSocket
    if (input.toLowerCase().includes('git') || input.toLowerCase().includes('branch')) {
      socketRef.current.emit('git_workflow', { action: input })
    } else if (input.toLowerCase().includes('explain') || input.toLowerCase().includes('code')) {
      socketRef.current.emit('code_request', { code: input, request: 'explain' })
    } else {
      socketRef.current.emit('message', { message: input })
    }
  }

  const quickActions = [
    { icon: Code, label: 'Explain Code', action: 'Explain this code block' },
    { icon: GitBranch, label: 'Git Workflow', action: 'Create a new branch and commit changes' },
    { icon: FileText, label: 'Code Review', action: 'Review this code for improvements' },
    { icon: Terminal, label: 'Run Command', action: 'Execute npm test' }
  ]

  return (
    <div className="flex h-screen bg-gradient-to-br from-monster-50 to-monster-100">
      {/* Sidebar */}
      <div className="w-64 bg-white/80 backdrop-blur-sm border-r border-monster-200 p-4">
        <div className="flex items-center gap-2 mb-6">
          <div className="w-8 h-8 bg-gradient-to-r from-monster-500 to-monster-600 rounded-lg flex items-center justify-center">
            <Code className="w-5 h-5 text-white" />
          </div>
          <h1 className="text-xl font-bold text-monster-800">Monster Code</h1>
        </div>

        <div className="space-y-2 mb-6">
          <h3 className="text-sm font-semibold text-monster-700 mb-3">Quick Actions</h3>
          {quickActions.map((action) => (
            <button
              key={action.label}
              type="button"
              onClick={() => setInput(action.action)}
              className="w-full flex items-center gap-2 p-2 rounded-lg hover:bg-monster-100 transition-colors text-sm text-monster-700"
            >
              <action.icon className="w-4 h-4" />
              <span>{action.label}</span>
            </button>
          ))}
        </div>

        <div className="space-y-2">
          <h3 className="text-sm font-semibold text-monster-700 mb-3">Tools</h3>
          <button type="button" className="w-full flex items-center gap-2 p-2 rounded-lg hover:bg-monster-100 transition-colors text-sm text-monster-700">
            <Settings className="w-4 h-4" />
            <span>Settings</span>
          </button>
        </div>
      </div>

      {/* Main Chat Interface */}
      <div className="flex-1 flex flex-col">
        {/* Header */}
        <div className="bg-white/80 backdrop-blur-sm border-b border-monster-200 p-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-2">
              <MessageSquare className="w-5 h-5 text-monster-600" />
              <h2 className="text-lg font-semibold text-monster-800">Monster Code Assistant</h2>
            </div>
            <div className="flex items-center gap-2">
              <div className={`w-2 h-2 rounded-full ${isConnected ? 'bg-green-500 animate-pulse' : 'bg-red-500'}`}></div>
              <span className="text-sm text-monster-600">{isConnected ? 'Connected' : 'Disconnected'}</span>
            </div>
          </div>
        </div>

        {/* Messages */}
        <div className="flex-1 overflow-y-auto p-4 space-y-4">
          {messages.length === 0 && (
            <div className="flex flex-col items-center justify-center h-full text-monster-600">
              <Code className="w-16 h-16 mb-4 opacity-50" />
              <h3 className="text-xl font-semibold mb-2">Welcome to Monster Code</h3>
              <p className="text-center max-w-md">
                I&apos;m your agentic coding assistant. Ask me to explain code, handle git workflows,
                execute routine tasks, or help with any development challenges.
              </p>
            </div>
          )}

          {messages.map((message) => (
            <div
              key={message.id}
              className={`flex ${message.type === 'user' ? 'justify-end' : 'justify-start'}`}
            >
              <div
                className={`max-w-2xl rounded-lg p-3 ${
                  message.type === 'user'
                    ? 'bg-gradient-to-r from-monster-500 to-monster-600 text-white'
                    : 'bg-white border border-monster-200 text-monster-800'
                }`}
              >
                <p className="text-sm">{message.content}</p>
                <p className={`text-xs mt-1 ${
                  message.type === 'user' ? 'text-monster-100' : 'text-monster-500'
                }`}>
                  {message.timestamp.toLocaleTimeString()}
                </p>
              </div>
            </div>
          ))}

          {isTyping && (
            <div className="flex justify-start">
              <div className="bg-white border border-monster-200 rounded-lg p-3">
                <div className="flex items-center gap-1">
                  <div className="w-2 h-2 bg-monster-400 rounded-full animate-bounce"></div>
                  <div className="w-2 h-2 bg-monster-400 rounded-full animate-bounce" style={{animationDelay: '0.1s'}}></div>
                  <div className="w-2 h-2 bg-monster-400 rounded-full animate-bounce" style={{animationDelay: '0.2s'}}></div>
                </div>
              </div>
            </div>
          )}
          <div ref={messagesEndRef} />
        </div>

        {/* Input */}
        <div className="bg-white/80 backdrop-blur-sm border-t border-monster-200 p-4">
          <form onSubmit={handleSubmit} className="flex gap-2">
            <input
              type="text"
              value={input}
              onChange={(e) => setInput(e.target.value)}
              placeholder="Ask Monster Code to explain code, handle git workflows, or execute tasks..."
              className="flex-1 px-4 py-2 border border-monster-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-monster-500 focus:border-transparent"
            />
            <button
              type="submit"
              disabled={!input.trim() || isTyping}
              className="px-4 py-2 bg-gradient-to-r from-monster-500 to-monster-600 text-white rounded-lg hover:from-monster-600 hover:to-monster-700 disabled:opacity-50 disabled:cursor-not-allowed transition-all flex items-center gap-2"
            >
              <Send className="w-4 h-4" />
              Send
            </button>
          </form>
        </div>
      </div>
    </div>
  )
}
