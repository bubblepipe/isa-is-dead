#import "@preview/polylux:0.4.0": *

#set text(font: ("PingFang SC", "Microsoft YaHei", "Source Han Sans CN"), lang: "zh")
#set page(paper: "presentation-16-9")

#show: polylux-config.with()

// 主题配置
#let accent-color = rgb("#00ff88")
#let secondary-color = rgb("#0088ff")
#let danger-color = rgb("#ff6b6b")
#let bg-color = rgb("#0a0a0a")
#let text-color = rgb("#ffffff")

// 自定义样式
#let slide-template(title: none, content) = {
  set page(fill: bg-color, margin: 2em)
  set text(fill: text-color, size: 20pt)
  
  if title != none {
    text(size: 32pt, fill: accent-color, weight: "bold")[#title]
    v(1em)
  }
  
  content
}

#let highlight(content) = text(fill: accent-color, weight: "bold")[#content]
#let emphasis(content) = text(fill: danger-color, weight: "bold")[#content]
#let stat(number) = text(size: 48pt, fill: accent-color, weight: "bold")[#number]

// 幻灯片 1: 标题页
#polylux-slide[
  #set align(center + horizon)
  #text(size: 48pt, weight: "bold")[
    #text(fill: gradient.linear(accent-color, secondary-color))[ISA已死，]
    #linebreak()
    #text(fill: gradient.linear(accent-color, secondary-color))[ISA万岁]
  ]
  #v(1em)
  #text(size: 24pt, fill: gray)[当CPU成为万能翻译器]
  #v(2em)
  #text(size: 18pt, fill: gray.darken(20%))[15分钟的CPU架构演变之旅]
]

// 幻灯片 2: 巨大的谎言
#slide-template(title: "CPU对你撒的弥天大谎")[
  #text(size: 28pt)[
    你写的每一条指令...
    
    #highlight[从未真正在硬件上执行]
  ]
  
  #v(1em)
  #align(center)[
    #box(stroke: 2pt + gray, radius: 5pt, inset: 1em)[x86/ARM代码] 
    #h(1em) → #h(1em)
    #box(stroke: 2pt + danger-color, radius: 5pt, inset: 1em)[#emphasis[魔法翻译]]
    #h(1em) → #h(1em)
    #box(stroke: 2pt + gray, radius: 5pt, inset: 1em)[微操作]
  ]
  
  #v(2em)
  #align(center)[
    #stat[28%]
    #linebreak()
    #text(size: 18pt, fill: gray)[的CPU功耗用于翻译]
  ]
]

// 幻灯片 3: 议程
#slide-template(title: "今天的旅程")[
  #set text(size: 22pt)
  - 📜 #highlight[历史：] 从简单处理器到复杂翻译器
  - 🔮 #highlight[现代魔法：] CPU如何表演魔术
  - 💸 #highlight[浪费：] 数十亿花在重复工作上
  - 🎮 #highlight[GPU智慧：] 一种有效的不同方法
  - 🚀 #highlight[未来：] OS和CPU携手共舞
]

// 幻灯片 4: 简单的时代
#slide-template(title: "1974年：当指令还很诚实的时候")[
  #table(
    columns: (auto, auto),
    stroke: none,
    [#text(fill: secondary-color, weight: "bold")[1974]], [Intel 8080 & MOS 6502 - 直接执行],
    [#text(fill: secondary-color, weight: "bold")[1980年代]], [大辩论：CISC vs RISC]
  )
  
  #v(1em)
  #grid(
    columns: (1fr, 1fr),
    gutter: 2em,
    box(stroke: 2pt + gray, radius: 10pt, inset: 1.5em)[
      #text(size: 24pt, fill: secondary-color)[CISC哲学]
      
      "硬件比软件快"
      - 复杂指令
      - 每条指令做更多事
    ],
    box(stroke: 2pt + gray, radius: 10pt, inset: 1.5em)[
      #text(size: 24pt, fill: secondary-color)[RISC哲学]
      
      "简单就是美"
      - 每周期一条指令
      - 让编译器优化
    ]
  )
]

// 幻灯片 5: 剧情反转
#slide-template(title: "剧情反转：CISC偷偷变成了RISC")[
  #align(center)[
    #text(size: 28pt)[现代x86处理器是]
    #v(0.5em)
    #text(size: 36pt)[#highlight["穿着CISC外衣的RISC内核"]]
  ]
  
  #v(2em)
  #align(center)[
    #box(stroke: 2pt + gray, radius: 5pt, inset: 0.8em)[复杂x86] 
    → 
    #box(stroke: 2pt + gray, radius: 5pt, inset: 0.8em)[解码器]
    → 
    #box(stroke: 2pt + gray, radius: 5pt, inset: 0.8em)[简单μOPs]
    → 
    #box(stroke: 2pt + gray, radius: 5pt, inset: 0.8em)[RISC核心]
  ]
]

// 幻灯片 6: 今天的玩家
#slide-template(title: "今天的架构格局")[
  #grid(
    columns: (1fr, 1fr),
    rows: (auto, auto),
    gutter: 1.5em,
    box(stroke: 2pt + gray, radius: 10pt, inset: 1.2em)[
      #text(size: 24pt, fill: secondary-color)[x86-64]
      
      👑 桌面/服务器之王
      - 向后兼容
      - 原始性能
      - 复杂翻译
    ],
    box(stroke: 2pt + gray, radius: 10pt, inset: 1.2em)[
      #text(size: 24pt, fill: secondary-color)[ARM64]
      
      📱 移动冠军
      - 能效高
      - 设计简洁
      - 苹果M系列
    ],
    grid.cell(colspan: 2)[
      #box(stroke: 2pt + gray, radius: 10pt, inset: 1.2em, width: 100%)[
        #text(size: 24pt, fill: secondary-color)[RISC-V]
        
        🔓 开源革命
        
        30%年增长率 • 无许可费 • 社区驱动
      ]
    ]
  )
]

// 幻灯片 7: 内部魔法
#slide-template(title: "现代超标量CPU内部")[
  你无辜的ADD指令会发生什么：
  
  #enum(
    [🔍 #highlight[解码：] x86 → 微操作],
    [🏷️ #highlight[重命名：] 消除虚假依赖],
    [⏳ #highlight[调度：] 寻找就绪操作],
    [⚡ #highlight[执行：] 在多个单元上运行],
    [✅ #highlight[退休：] 维持程序顺序假象]
  )
  
  #v(1em)
  #align(center)[
    #emphasis[这是一个以GHz速度工作的全职翻译器！]
  ]
]

// 幻灯片 8: 记分板和保留站
#slide-template(title: "大脑：记分板与保留站")[
  #grid(
    columns: (1fr, 1fr),
    gutter: 2em,
    box(stroke: 2pt + gray, radius: 10pt, inset: 1em)[
      #text(size: 22pt, fill: secondary-color)[记分板 (CDC 6600, 1964)]
      
      📋 跟踪指令状态
      - 哪些单元忙碌？
      - 哪些寄存器正在写入？
      - 操作数准备好了吗？
      
      #emphasis[集中控制]
    ],
    box(stroke: 2pt + gray, radius: 10pt, inset: 1em)[
      #text(size: 22pt, fill: secondary-color)[保留站（现代）]
      
      🎯 分布式调度
      - 每个执行单元有缓冲区
      - 指令等待操作数
      - 准备好就执行
      
      #highlight[像智能候诊室]
    ]
  )
  
  #v(1em)
  #box(fill: rgb("#1a1a1a"), radius: 5pt, inset: 1em, width: 100%)[
    ```
    ADD R1, R2, R3  → 在RS中等待直到R2和R3准备好
    MUL R4, R1, R5  → 等待ADD结果 + R5
    SUB R6, R7, R8  → 如果R7和R8准备好可立即执行！
    ```
  ]
]

// 幻灯片 9: μOP缓存
#slide-template(title: "Intel的聪明把戏：μOP缓存")[
  #align(center)[
    #stat[1,536]
    #linebreak()
    #text(size: 18pt, fill: gray)[个预解码的微操作存储]
  ]
  
  #v(1em)
  #grid(
    columns: (1fr, 1fr),
    gutter: 2em,
    box(stroke: 2pt + gray, radius: 10pt, inset: 1em)[
      #text(size: 22pt, fill: secondary-color)[缓存命中（80%）]
      
      ✅ 跳过解码流水线
      ✅ 节省功耗
      ✅ 更快执行
    ],
    box(stroke: 2pt + gray, radius: 10pt, inset: 1em)[
      #text(size: 22pt, fill: secondary-color)[缓存未命中（20%）]
      
      ❌ 需要完整解码
      ❌ 耗电
      ❌ 性能损失
    ]
  )
  
  #v(1em)
  #align(center)[就像餐厅预先准备受欢迎的菜肴！]
]

// 幻灯片 10: 十亿美元的浪费
#slide-template(title: "十亿美元的低效")[
  #align(center)[
    #text(size: 26pt)[
      #emphasis[当缓存行被驱逐时]
      #linebreak()
      #emphasis[所有翻译工作都被丢弃]
    ]
  ]
  
  #v(1em)
  想象一个翻译员必须：
  - 反复翻译同一份文件
  - 需要空间时烧毁所有翻译
  - 每次从头开始
  
  #v(1em)
  #align(center)[
    #stat[28%]
    #linebreak()
    #text(size: 18pt, fill: gray)[的CPU功耗浪费在重复翻译上]
  ]
]

// 幻灯片 11: GPU解决方案
#slide-template(title: "GPU已经解决了这个问题")[
  #align(center)[
    CUDA/OpenCL → #highlight[PTX（虚拟ISA）] → 驱动JIT → SASS（真实ISA）
  ]
  
  #v(1em)
  #grid(
    columns: (1fr, 1fr),
    gutter: 2em,
    box(stroke: 2pt + gray, radius: 10pt, inset: 1em)[
      #text(size: 22pt, fill: secondary-color)[关键洞察]
      
      • 加载时编译一次
      • 不是执行期间数百万次
      • 15-20%性能提升
    ],
    box(stroke: 2pt + gray, radius: 10pt, inset: 1em)[
      #text(size: 22pt, fill: secondary-color)[好处]
      
      • 前向兼容性
      • 架构特定优化
      • 无重复工作
    ]
  )
]

// 幻灯片 12: VLIW
#slide-template(title: "VLIW：少有人走的路")[
  #align(center)[
    #text(size: 28pt)[将复杂性从#emphasis[硬件]转移到#highlight[编译器]]
  ]
  
  #v(1em)
  #grid(
    columns: (1fr, 1fr),
    gutter: 2em,
    box(stroke: 2pt + gray, radius: 10pt, inset: 1em)[
      #text(size: 22pt, fill: secondary-color)[管弦乐模型]
      
      🎼 VLIW = 交响乐
      每个人精确地遵循乐谱
    ],
    box(stroke: 2pt + gray, radius: 10pt, inset: 1em)[
      #text(size: 22pt, fill: secondary-color)[爵士乐模型]
      
      🎺 OoO = 爵士乐队
      根据条件即兴创作
    ]
  )
  
  #v(1em)
  #align(center)[
    #highlight[成功：] DSP、嵌入式系统
    
    #emphasis[失败：] Intel Itanium用于通用计算
  ]
]

// 幻灯片 13: OS/CPU协同设计
#slide-template(title: "当OS和CPU携手共舞")[
  #align(center)[
    #text(size: 26pt)[#highlight[苹果M系列：完美的合作伙伴]]
  ]
  
  #v(1em)
  - 🎯 统一内存架构
  - ⚡ macOS操作的自定义指令
  - 🔋 深度电源管理集成
  - 🚀 结果："低功耗硅片中世界上最快的CPU核心"
  
  #v(1em)
  其他例子：
  
  #highlight[CHERI：] 硬件-软件安全协同设计
  
  #highlight[Transmeta：] 证明软件翻译可行（33%开销）
]

// 幻灯片 14: 激进的提议
#slide-template(title: "激进的提议")[
  #align(center)[
    #text(size: 26pt)[如果#highlight[OS]成为#emphasis["CPU驱动"]会怎样？]
  ]
  
  #v(1em)
  #align(center)[
    程序 → #highlight[OS调度器] → VLIW后端
  ]
  
  #v(1em)
  #grid(
    columns: (1fr, 1fr),
    gutter: 2em,
    box(stroke: 2pt + gray, radius: 10pt, inset: 1em)[
      #text(size: 22pt, fill: secondary-color)[OS职责]
      
      • 分析依赖关系
      • 打包操作
      • 系统范围优化
    ],
    box(stroke: 2pt + gray, radius: 10pt, inset: 1em)[
      #text(size: 22pt, fill: secondary-color)[CPU变成]
      
      • 简单VLIW执行器
      • 无OoO复杂性
      • 30%功耗降低
    ]
  )
]

// 幻灯片 15: 挑战
#slide-template(title: "为什么这很困难")[
  - ⏱️ #emphasis[上下文切换：] 昂贵的调度状态
  - 🎯 #emphasis[实时响应：] 软件调度延迟
  - 🔄 #emphasis[兼容性：] 遗留软件支持
  - 🔒 #emphasis[安全性：] 新的攻击向量
  
  #v(1em)
  #box(stroke: 2pt + gray, radius: 10pt, inset: 1em, width: 100%)[
    #text(size: 22pt, fill: secondary-color)[前进道路]
    
    1. 从专门领域开始（AI、DSP）
    2. 硬件-软件混合方法
    3. 专注于功效而非原始速度
  ]
]

// 幻灯片 16: 未来
#slide-template(title: "ISA的未来")[
  #align(center)[
    #text(size: 26pt)[ISA将成为#highlight[纯粹的虚拟抽象]]
  ]
  
  #v(1em)
  - 🌐 OS和硬件在翻译上协作
  - 🎯 特定领域架构激增
  - 🔓 开放标准实现快速实验
  - 🔄 编译器、OS和硬件边界模糊
  
  #v(2em)
  #align(center)[
    #text(size: 24pt)[#emphasis[抽象实现创新]]
  ]
]

// 幻灯片 17: 结论
#polylux-slide[
  #set align(center + horizon)
  #text(size: 42pt, weight: "bold")[
    ISA已死
    #linebreak()
    #highlight[ISA万岁]
  ]
  
  #v(1em)
  #text(size: 20pt, fill: gray)[
    作为硬件规范已死
    #linebreak()
    作为抽象层永生
  ]
  
  #v(2em)
  未来属于那些能够
  
  #text(size: 28pt)[#highlight[适应]、#emphasis[翻译]和#highlight[优化]]
  
  以设计者从未想象过的方式的架构
]

// 幻灯片 18: 谢谢
#polylux-slide[
  #set align(center + horizon)
  #text(size: 48pt, weight: "bold")[谢谢！]
  
  #v(1em)
  #text(size: 24pt, fill: gray)[有问题吗？]
  
  #v(2em)
  关键要点：
  #align(left)[
    - 现代CPU是翻译器，不是执行器
    - 28%的功耗浪费在重复翻译上
    - OS-CPU协同设计是未来
    - 抽象实现创新
  ]
]