using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.DAL.Interfaces;
using backendPoSlojevima.Models;
using backendPoSlojevima.Data;

namespace backendPoSlojevima.DAL
{
    public class KategorijeProblemaDAL : IKategorijeProblemaDAL
    {
        private readonly ApplicationDbContext _context;
        public  KategorijeProblemaDAL (ApplicationDbContext context)
        {
            _context = context;
        }
        public List<KategorijeProblema> getKategorijeProblema()
        {
            return _context.kategorija_problema.ToList();
        }
    }
}
