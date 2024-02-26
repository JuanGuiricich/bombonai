class SendMessageJob < ApplicationJob
  queue_as :default

  def perform(user_id, message_content)
  user = User.find(user_id)
  message_history = user.messages.order(created_at: :asc)

  messages_conversation = message_history.map do |message|
    {
      role: message.is_user_message ? "user" : "assistant",
      content: message.content
    }
  end

  messages_conversation << { role: "user", content: message_content }

  api_request = {
    max_new_tokens: 120,
    seed: -1,
    temperature: 0.87,
    top_p: 0.99,
    top_k: 50,
    typical_p: 0.68,
    epsilon_cutoff: 0,
    eta_cutoff: 0,
    repetition_penalty: 1.1,
    repetition_penalty_range: 0,
    encoder_repetition_penalty: 1,
    no_repeat_ngram_size: 0,
    min_length: 0,
    do_sample: true,
    penalty_alpha: 0,
    num_beams: 1,
    length_penalty: 1,
    early_stopping: false,
    mirostat_mode: 0,
    mirostat_tau: 5,
    mirostat_eta: 0.1,
    add_bos_token: true,
    ban_eos_token: false,
    truncation_length: 2048,
    custom_stopping_strings: "",
    skip_special_tokens: true,
    stream: false,
    tfs: 0.68,
    top_a: 0,
    chat_generation_attempts: 1,
    stop_at_newline: true,
    mode: "chat",
    instruction_template: "Bactrian",
    name1_instruct: "### Input:",
    name2_instruct: "### Output:",
    context_instruct: "",
    turn_template: "<|user|>\n<|user-message|>\n\n<|bot|>\n<|bot-message|>\n\n",
    chat_style: "cai-chat",
    chat_instruct_command: "Continue the chat dialogue below. Write a single reply for the character \"<|character|>\". <|prompt|>",
    loader: "Transformers",
    cpu_memory: 0,
    auto_devices: false,
    disk: false,
    cpu: false,
    bf16: false,
    load_in_8bit: false,
    trust_remote_code: false,
    load_in_4bit: false,
    compute_dtype: "float16",
    quant_type: "nf4",
    use_double_quant: false,
    wbits: "None",
    groupsize: "None",
    model_type: "llama",
    pre_layer: 0,
    triton: false,
    desc_act: false,
    no_inject_fused_attention: false,
    no_inject_fused_mlp: false,
    no_use_cuda_fp16: false,
    threads: 0,
    n_batch: 512,
    no_mmap: false,
    low_vram: false,
    mlock: false,
    n_gpu_layers: 0,
    n_ctx: 2048,
    n_gqa: 0,
    rms_norm_eps: 0,
    llama_cpp_seed: 0,
    gpu_split: "",
    max_seq_len: 2048,
    compress_pos_emb: 1,
    alpha_value: 1,
    gpu_memory_0: 0,
    messages: messages_conversation,
    your_name: user.username,
    user_input: message_content,
    name1: user.username,
    name2: "Tamara",
    gretting: "Hi handsome did you watch Boca's game last night?",
    context: "You are Tamara an Argentinian girl that is fan of Boca Juniors and loves to party hard.",
    character: "Example"
  }

  response = ChatService.send_message(api_request)

    if response.success?
      parsed_response = JSON.parse(response.body)
      ai_message_content = parsed_response["choices"][0]["message"]["content"]

      message = Message.create!(
        user_id: user_id,
        content: ai_message_content,
        is_user_message: false
      )
      broadcast_message(user_id, message)
    end
  end

  def broadcast_message(user_id, message)
    Turbo::StreamsChannel.broadcast_append_to "messages_#{user_id}",
                                            target: "messages_#{user_id}",
                                            partial: "messages/message",
                                            locals: { message: message }
  end
end
