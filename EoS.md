~# EoS (End of Study, not End of Service)~
# 테라폼 스터디 마무으리, 주의사항 위주
테라폼 자체로 할 수 있는 기술적인 이야기는 스터디 본문, 그리고 스터디원들의 과제 내용을 능가할 자신이 없다... 개인적으로 테라폼을 쓰면서 느꼈던 한계와 주의사항, 그리고 본 스터디를 통해 알게 된 새로운 방법 등을 소개해볼까 합니다. 

## Backend, State file and Deployment 
- 현재 사내에선 S3 백엔드에 상태 파일 저장 + DynamoDB 이용해 락 파일 저장 + Git을 이용한 테라폼 코드 관리 중 
- 테라폼 클라우드를 사용하지 않는 이상, 일정 규모 이상 조직에서 무료로테라폼을 이용한 협업 환경에선 가장 나은 선택이지 않을까 함. 
<br/>

- 다만 몇가지 겪었던 문제와 개인적인 개선점을 소개하자면
  - 락 상태 유지, 
    - 지난 반 년간 딱 한 번 겪음. 기존 작업자가 작업을 마쳤음에도 락 상태가 유지되어 다음 작업자가 ??. terraform lock=false 옵션으로 락 무시하고 작업 가능하지만, 순간 철렁. 
  - 자동화의 부족. 
    - Jenkins나 Github Action과 같은 CI/CD 파이프라인을 태우지 않다보니 겪는 문제인데, 마스터 브랜치 릴리즈와 자원 생성 모두를 수작업으로 관리해줘야 함. 
    - 또한 매번 terraform plan의 결과를 github PR 내에 수작업으로 복사하는 번거로움 수반. 
    - DNS 작업이 아닌 이상, 신규 리소스의 생성은 기존 리소스의 동작에 영향을 주지 않는 작업 -> 브랜치가 마스터로 머지 시 자동으로 terraform apply 되는 액션이 필요. 


## Iterate over resources 
- 기본적으로 terraform plan 시 will be changed(~), destroyed(-) 마크가 뜨는 경우 유의해야 한다고 생각. 
- 기존 리소스를 list 계열로 생성 후 코드 변경 시 전체 리소스가 삭제될 수 있음
```hcl
ec2s = ["ec2-1", "ec2-2"]
ec2s = ["ec2-1"]
# 리소스 하나만 삭제하고 싶어도, 테라폼은 ec2s 라는 리스트 자체를 하나의 객체로 인식하기 때문에 전체 삭제 후 ec2-1 하나만 생성하는 과정이 수반됨. 
```
- random_shuffle을 이용한 리소스 생성 후 변경 시에도 동일한 문제가 생길 수 있어 사용 시 유의해야 함. 


## Diverged by environment (Prod/Stg..) 
- 현재 사내에선 Prod/Stg/Dev 리소스가 하나의 모듈 내에 존재로 관리 중.
- 기능 추가 시 깃 레포 릴리즈 버전을 올리고 있음.
```bash
└── module(i.e.,)
    ├── common
    │   ├── cloudfront
    │   ├── ec2
    │   ├── elasticache
    │   ├── elb
    │   ├── s3
    │   └── vpc
    ├── dev
    ├── prod
    └── stg
```
```bash
master ───────────── master (merged)
   └── feature branch ──|
```
```hcl
# 각 리소스에선 릴리즈 태그로 참조 중
source = "git::git@github.com:foo/foo.git//module/common/ec2?ref=v1.0.1"
```

- 이는 한 눈에 모든 코드를 볼 수 있다는 장점이 있지만, 리소스가 늘어날수록 관리해야 하는 코드의 양이 늘어나는 단점이 있다고 생각됨.  
<br/>

- 스터디 발표 세션에서 들었던 것처럼 env별 서로 다른 브랜치를 사용하는 전략을 사용해볼 수 있을 것 있음. 코드 전반의 로직이나 내용은 동일하지만, git checkout으로 브랜치만 스위칭. 
```bash
└── module(i.e.,)
    ├── common
    │   ├── cloudfront
    │   ├── ec2
    │   ├── elasticache
    │   ├── elb
    │   ├── s3
    │   └── vpc
    └── resource
```
```bash
master
   └─── prod
   └─── staging
   └─── dev
```
- 예를 들어, A라는 마이크로서비스의 ASG 그룹에 대해 코드 작업 필요 시 같은 경로에서 브랜치만 변경하면 된다는 점, 같은 로직의 코드를 여러번 작성할 필요가 없다는 점에서 매우 탐난다... 
```bash
기존
- module/prod/a/ec2/asg
- module/stg/a/ec2/asg 

브랜치 전략 시 
- resource/a/ec2/asg (git checkout) 
```
- 다만 코드 자체의 복잡도가 증가할 수 있다는 우려는 존재. 예를 들어, prod/stg 간 리소스 정책이 상이할 경우 (i.e.,prod 외의 환경에선 multi-az 등 이중화 미사용) 삼항 연산식 등으로 이를 예외 처리해줘야 함.
- 환경별 리소스 생성 시기가 차이가 있어, 구성이 상이한 경우가 많다면 본 브랜치 전략은 코드 작업 공수가 많을 수 있다는 생각. 레거시는 나의 원쑤! 

## DevOps Ground Rule 
- 코드 리뷰 중인 상태의 코드를 merge 전 선 apply를 해버린다면? 
  - 리뷰에서 코드의 오류를 잡아냈다 하더라도, 이를 변경하는 건 뼈아픈 시간. 기존 리소스가 온전히 떠있는 방안을 모색하면서 코드를 수정해야 하며, 불가할 경우 최악엔 서비스 중지가 필요...
  - 물론 오류 없는 로직대로 리소스를 먼저 콘솔에서 변경 -> 테라폼 코드 변경 -> Terraform import의 방법도 있지만, 그 누구도 이의 정합성을 보장하지 못함.
- 코드로 관리하기 시작한 자원은 끝까지 코드로 관리하자. 
  - 중간에 콘솔에서 변경한 내용이 있다면 plan 했을 때부터 테라폼이 '외부에서 변경됐다. 상태 파일 drift됨~' 이라고 경고를 날림. 
  - 변경 사항을 추적하고 다시 코드에 반영하는 시간이 상상 이상으로 소요됨. 특히 변경점을 내가 만든게 아니라면? 까마득하다.. 
  > Terraform is an open-source infrastructure as code software tool that enables you to safely and predictably create, change, and improve infrastructure.
  - 다시 한번 말하자면, 테라폼은 인프라 관리를 **편하게 하기 위한 도구**이다. 테라폼으로 관리하던 자원을 콘솔로 변경하기 시작하면, 추후 테라폼 형상을 맞추는 작업을 해야만 한다. 인프라 관리 도구를 위해 인프라를 탐색하고 맞춰야 하는 **주객전도**가 벌어지기 때문에 절대금지. 
