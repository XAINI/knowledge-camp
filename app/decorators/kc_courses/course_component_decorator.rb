KcCourses::Course.class_eval do
  def to_brief_component_data(controller = nil)
    # TODO 课程封面
    # TODO 课程发布时间
    {
      id: self.id.to_s,
      link: controller.course_path(self.id.to_s),
      img: 'http://i.teamkn.com/i/dHCg8ulr.png',
      name: self.title,
      desc: self.desc,
      instructor: self.user.name,
      published_at: self.updated_at.strftime("%Y-%m-%d")
    }
  end

  def to_detail_component_data(controller = nil)
    {
      id: self.id.to_s,
      link: controller.course_path(self.id.to_s),
      img: 'http://i.teamkn.com/i/dHCg8ulr.png',
      name: self.title,
      desc: self.desc,
      instructor: self.user.name,
      published_at: self.updated_at.strftime("%Y-%m-%d"),
      # TODO 统计信息方法等待封装完成
      subject: self.course_subjects.map(&:name),
      price: '免费',
      effort: '4 个视频，合计 120 分钟',

      chapters: self.chapters.map{|chapter|chapter.to_brief_component_data(controller)}
    }
  end
end

KcCourses::Chapter.class_eval do
  def to_brief_component_data(controller = nil)
    {
      name: self.title,
      wares: self.wares.map{|ware|ware.to_brief_component_data(controller)}
    }
  end
end

KcCourses::Ware.class_eval do
  def to_brief_component_data(controller = nil)
    percent = self.read_percent_of_user(controller.current_user)
    learned = 'done' if percent == 100
    learned = 'half' if percent > 0 && percent < 100
    learned = 'no'   if percent == 0

    data = {
      # TODO ware.type
      id: self.id.to_s,
      name: self.title,
      kind: self.type,
      learned: learned,
    }

    data[:kind] = "document"
    if self.type == SimpleAudio
      data[:kind] = "audio"
      data[:time] = self.file_entity.meta[:video][:total_duration]
    end

    if self.type == SimpleVideo
      data[:kind] = "video"
      data[:time] = self.file_entity.meta[:audio][:audio_duration]
      data[:video_url] = self.file_entity.transcode_url("超请")
    end

    data
  end
end